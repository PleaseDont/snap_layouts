//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <screen_retriever_windows/screen_retriever_windows_plugin_c_api.h>
#include <snap_layouts/snap_layouts_plugin.h>
#include <window_manager/window_manager_plugin.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  ScreenRetrieverWindowsPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("ScreenRetrieverWindowsPluginCApi"));
  SnapLayoutsPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("SnapLayoutsPlugin"));
  WindowManagerPluginRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("WindowManagerPlugin"));
}
