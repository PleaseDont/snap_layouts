# snap_layouts

[![pub version][pub-image]][pub-url]

[pub-image]: https://img.shields.io/pub/v/snap_layouts.svg
[pub-url]: https://pub.dev/packages/snap_layouts

This plugin provides a simple window layout button, `SnapLayoutsButton`, which can implement the native Windows 11 `Snap Layouts` feature.

---

English | [简体中文](./README-ZH.md)

---

## Supported Platforms

| Linux | macOS | Windows | iOS | Android |
| :---: | :---: | :-----: | :---: | :---: |
|   ❌   |   ❌   |    ✔️    |   ❌   |   ❌   |

## Features

- Native Windows 11-style Snap Layouts button
- Default Windows 11-style window title bar
- Integration with the `window_manager` plugin
- Full customization support

## Quick Start

### Installation

```shell
flutter pub add snap_layouts
flutter pub add window_manager
```

Or add the following to your `pubspec.yaml`:

```yaml
dependencies:
  snap_layouts: ^0.2.0
  window_manager: ^0.5.0
```

### Usage

You can directly check the [example](./example/lib/main.dart).

#### `SnapLayoutsButton`

Place the button on your page.

```dart
import 'package:flutter/material.dart';
import 'package:snap_layouts/snap_layouts.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();
  WindowOptions windowOptions = WindowOptions(
    // Ensure this option
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

Place the title bar on your page.

```dart
import 'package:flutter/material.dart';
import 'package:snap_layouts/snap_layouts.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();
  WindowOptions windowOptions = WindowOptions(
    // Ensure this option
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

## References

- https://learn.microsoft.com/en-us/windows/apps/desktop/modernize/ui/apply-snap-layout-menu
- https://github.com/luoluoqixi/flutter_windows11_snap_layouts_examples.git
- https://github.com/grassator/win32-window-custom-titlebar
- https://github.com/leanflutter/window_manager

## License

[MIT](./LICENSE)