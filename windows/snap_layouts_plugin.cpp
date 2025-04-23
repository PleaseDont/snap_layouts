#include "include/snap_layouts/snap_layouts_plugin.h"

#include <windows.h>
// This must be included before many other Windows headers.
#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#define IDT_HOVER_MONITOR 2233

namespace {

class SnapLayoutsPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  SnapLayoutsPlugin(flutter::PluginRegistrarWindows *registrar);
  virtual ~SnapLayoutsPlugin();

  std::optional<LRESULT> HandleWindowProc(HWND hWnd, UINT message,
                                          WPARAM wParam, LPARAM lParam);

  void OnSnapLayoutsTimer(HWND hWnd, UINT uMsg, UINT_PTR idEvent, DWORD dwTime);

  SnapLayoutsPlugin(const SnapLayoutsPlugin &) = delete;
  SnapLayoutsPlugin &operator=(const SnapLayoutsPlugin &) = delete;

 private:
  flutter::PluginRegistrarWindows *registrar;
  int window_proc_id = -1;

  RECT snapLayoutsRect = {};
  bool enabled = true;
  bool snapLayoutsHovered = false;
  bool snapLayoutsTiming = false;
  bool snapLayoutsDown = false;

  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  void setSnapLayoutsHovered(HWND hWnd);

  void _EmitEvent(std::string eventName);
};

SnapLayoutsPlugin *instance = nullptr;
WNDPROC originalWndProc = nullptr;
std::unique_ptr<
    flutter::MethodChannel<flutter::EncodableValue>,
    std::default_delete<flutter::MethodChannel<flutter::EncodableValue>>>
    channel = nullptr;

static LRESULT CALLBACK WndProc(HWND const hWnd, UINT const message,
                                WPARAM const wParam,
                                LPARAM const lParam) noexcept {
  if (instance) {
    auto customResult =
        instance->HandleWindowProc(hWnd, message, wParam, lParam);
    if (customResult) {
      return customResult.value();
    }
  }
  if (originalWndProc) {
    LRESULT result =
        CallWindowProc(originalWndProc, hWnd, message, wParam, lParam);
    return result;
  }
  return DefWindowProc(hWnd, message, wParam, lParam);
}

void CALLBACK SnapLayoutsTimerProc(HWND hWnd, UINT uMsg, UINT_PTR idEvent,
                                   DWORD dwTime) {
  if (instance) instance->OnSnapLayoutsTimer(hWnd, uMsg, idEvent, dwTime);
}

void SnapLayoutsPlugin::RegisterWithRegistrar(
    flutter::PluginRegistrarWindows *registrar) {
  channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
      registrar->messenger(), "snap_layouts",
      &flutter::StandardMethodCodec::GetInstance());

  auto plugin = std::make_unique<SnapLayoutsPlugin>(registrar);

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  registrar->AddPlugin(std::move(plugin));
}

SnapLayoutsPlugin::SnapLayoutsPlugin(flutter::PluginRegistrarWindows *registrar)
    : registrar(registrar) {
  window_proc_id = registrar->RegisterTopLevelWindowProcDelegate(
      [this](HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam) {
        return HandleWindowProc(hWnd, message, wParam, lParam);
      });
  instance = this;
  HWND hWnd = GetAncestor(registrar->GetView()->GetNativeWindow(), GA_ROOT);
  originalWndProc = reinterpret_cast<WNDPROC>(SetWindowLongPtr(
      hWnd, GWLP_WNDPROC, reinterpret_cast<LONG_PTR>(WndProc)));
}

SnapLayoutsPlugin::~SnapLayoutsPlugin() {
  registrar->UnregisterTopLevelWindowProcDelegate(window_proc_id);
  channel = nullptr;
}

void SnapLayoutsPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("updateSnapLayoutsRect") == 0) {
    const auto *arguments =
        std::get_if<flutter::EncodableMap>(method_call.arguments());
    snapLayoutsRect.left =
        std::get<int32_t>(arguments->at(flutter::EncodableValue("left")));
    snapLayoutsRect.top =
        std::get<int32_t>(arguments->at(flutter::EncodableValue("top")));
    snapLayoutsRect.right =
        std::get<int32_t>(arguments->at(flutter::EncodableValue("right")));
    snapLayoutsRect.bottom =
        std::get<int32_t>(arguments->at(flutter::EncodableValue("bottom")));

    result->Success(flutter::EncodableValue(true));
  } else if (method_call.method_name().compare("enableSnapLayouts") == 0) {
    const auto *arguments =
        std::get_if<flutter::EncodableMap>(method_call.arguments());
    enabled = std::get<bool>(arguments->at(flutter::EncodableValue("enabled")));
    result->Success();
  } else {
    result->NotImplemented();
  }
}

void SnapLayoutsPlugin::setSnapLayoutsHovered(HWND hWnd) {
  POINT cursorPoint;
  GetCursorPos(&cursorPoint);
  ScreenToClient(hWnd, &cursorPoint);

  bool hovering = PtInRect(&snapLayoutsRect, cursorPoint);

  if (hovering & !snapLayoutsHovered) {
    _EmitEvent("snap-layouts-hover");
    snapLayoutsHovered = true;

    if (snapLayoutsTiming) KillTimer(hWnd, IDT_HOVER_MONITOR);
    SetTimer(hWnd, IDT_HOVER_MONITOR, 24, SnapLayoutsTimerProc);
    snapLayoutsTiming = true;
  } else if (!hovering & snapLayoutsHovered) {
    _EmitEvent("snap-layouts-leave");
    snapLayoutsHovered = false;

    if (snapLayoutsTiming) KillTimer(hWnd, IDT_HOVER_MONITOR);
    snapLayoutsTiming = false;
  }
}

void SnapLayoutsPlugin::OnSnapLayoutsTimer(HWND hWnd, UINT uMsg,
                                           UINT_PTR idEvent, DWORD dwTime) {
  if (idEvent == IDT_HOVER_MONITOR) setSnapLayoutsHovered(hWnd);
}

void SnapLayoutsPlugin::_EmitEvent(std::string eventName) {
  if (channel == nullptr) return;

  flutter::EncodableMap args = flutter::EncodableMap();
  args[flutter::EncodableValue("eventName")] =
      flutter::EncodableValue(eventName);
  channel->InvokeMethod("onEvent",
                        std::make_unique<flutter::EncodableValue>(args));
}

std::optional<LRESULT> SnapLayoutsPlugin::HandleWindowProc(HWND hWnd, UINT uMsg,
                                                           WPARAM wParam,
                                                           LPARAM lParam) {
  if (!enabled) return std::nullopt;
  switch (uMsg) {
    case WM_SIZE: {
      _EmitEvent("snap-layouts-locate");
      break;
    }
    case WM_MOUSEMOVE: {
      setSnapLayoutsHovered(hWnd);
      break;
    }
    case WM_NCMOUSEMOVE: {
      setSnapLayoutsHovered(hWnd);
      break;
    }
    case WM_NCHITTEST: {
      if (snapLayoutsHovered) return HTMAXBUTTON;
      break;
    }
    case WM_NCLBUTTONDOWN: {
      if (snapLayoutsHovered) {
        _EmitEvent("snap-layouts-down");
        snapLayoutsDown = true;
        return HTNOWHERE;
      }
      break;
    }
    case WM_NCLBUTTONUP: {
      if (snapLayoutsHovered) {
        _EmitEvent("snap-layouts-up");
        if (snapLayoutsDown) _EmitEvent("snap-layouts-click");
        snapLayoutsDown = false;
        return HTNOWHERE;
      }
      break;
    }
  }
  return std::nullopt;
}
}  // namespace

void SnapLayoutsPluginRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  SnapLayoutsPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}