import 'package:flutter/material.dart';
import 'dart:async';

import 'package:snap_layouts/snap_layouts.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();

  const size = Size(800, 600);
  WindowOptions windowOptions = WindowOptions(
    size: size,
    minimumSize: size,
    center: true,
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
  bool _isLight = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _isLight ? ThemeMode.light : ThemeMode.dark,
      home: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kWindowCaptionHeight),
          child: SnapLayoutsCaption(
            brightness: _isLight ? Brightness.light : Brightness.dark,
            title: Text('snap_layouts_example'),
            actions: [
              WindowCaptionAction(
                icon: Icon(
                  _isLight
                      ? Icons.wb_sunny_outlined
                      : Icons.nightlight_outlined,
                ),
                onPressed: () async {
                  await windowManager.setBrightness(
                    _isLight ? Brightness.dark : Brightness.light,
                  );
                  setState(() {
                    _isLight = !_isLight;
                  });
                },
              ),
            ],
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                width: .1,
                color: _isLight ? Colors.black : Colors.white,
              ),
            ),
          ),
          child: Center(child: Text('Snap Layouts Example')),
        ),
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

/* import 'package:flutter/material.dart';
import 'package:snap_layouts/snap_layouts.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();
  WindowOptions windowOptions = WindowOptions(
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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: SizedBox(width: 46, height: 32, child: SnapLayoutsButton()),
        ),
      ),
    );
  }
} */

/* import 'package:flutter/material.dart';
import 'package:snap_layouts/snap_layouts.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();
  WindowOptions windowOptions = WindowOptions(
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
} */
