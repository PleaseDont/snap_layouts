# snap_layouts

[![pub version][pub-image]][pub-url]

[pub-image]: https://img.shields.io/pub/v/snap_layouts.svg
[pub-url]: https://pub.dev/packages/snap_layouts

此插件提供了一个简单的窗口布局按钮 `SnapLayoutsButton`，此按钮可以实现 Windows 11 原生 `Snap Layouts` 功能。

---

[English](./README.md) | 简体中文

---

## 支持的平台

| Linux | macOS | Windows | iOS | Android |
| :---: | :---: | :-----: | :---: | :---: |
|   ❌   |   ❌   |    ✔️    |   ❌   |   ❌   |

## 特性

- 原生 Windows 11 风格的 Snap Layouts 按钮
- 默认风格的 Windows 11 风格的窗口标题栏
- 与 `window_manager` 插件集成
- 完全自定义支持

## 快速开始

### 安装

```shell
flutter pub add snap_layouts
flutter pub add window_manager
```

或者在 `pubspec.yaml` 中添加:

```yaml
dependencies:
  snap_layouts: ^0.1.0
  window_manager: ^0.4.3
```

### 使用

你可以直接查看 [example](./example/lib/main.dart).


#### `SnapLayoutsButton`

把按钮放入页面。

```dart
import 'package:flutter/material.dart';
import 'package:snap_layouts/snap_layouts.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();
  WindowOptions windowOptions = WindowOptions(
    // 确保开启此选项
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(width: 46, height: 32, child: SnapLayoutsButton()),
        ),
      ),
    );
  }
}
```

#### `SnapLayoutsCaption`

把标题栏放入页面。

```dart
import 'package:flutter/material.dart';
import 'package:snap_layouts/snap_layouts.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();
  WindowOptions windowOptions = WindowOptions(
    // 确保开启此选项
    titleBarStyle: TitleBarStyle.hidden,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WindowListener {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kWindowCaptionHeight),
          child: SnapLayoutsCaption(
            title: Text('snap_layouts_example'),
            actions: [
              WindowCaptionAction(
                icon: Icon(Icons.favorite_outline),
                onPressed: () {},
              ),
            ],
          ),
        ),
        body: Center(child: Text('Snap Layouts Example')),
      ),
    );
  }

  @override
  void onWindowMaximize() {
    setState(() {});
  }

  @override
  void onWindowUnmaximize() {
    setState(() {});
  }
}
```

## 参考

- https://learn.microsoft.com/en-us/windows/apps/desktop/modernize/ui/apply-snap-layout-menu
- https://github.com/luoluoqixi/flutter_windows11_snap_layouts_examples.git
- https://github.com/grassator/win32-window-custom-titlebar
- https://github.com/leanflutter/window_manager

## 许可证

[MIT](./LICENSE)