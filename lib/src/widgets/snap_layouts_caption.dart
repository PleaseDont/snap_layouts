import 'package:flutter/material.dart';
import 'package:snap_layouts/src/widgets/snap_layouts_button.dart';
import 'package:window_manager/window_manager.dart';

/// A customizable window caption widget with Windows 11 style controls
class WindowCaptionAction extends StatelessWidget {
  const WindowCaptionAction({super.key, required this.icon, this.onPressed});

  final Widget icon; // The icon to display
  final VoidCallback? onPressed; // Callback when button is pressed

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      constraints: BoxConstraints.tight(Size(28, 28)),
      padding: EdgeInsets.zero,
      iconSize: 16,
      icon: icon,
      highlightColor: Colors.transparent,
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }
}

/// A Windows 11 style window caption bar with snap layout support
class SnapLayoutsCaption extends StatefulWidget {
  const SnapLayoutsCaption({
    super.key,
    this.icon,
    this.title,
    this.backgroundColor,
    this.brightness,
    this.actions = const [],
    this.snapLayoutsEnabled = true,
  });

  final Widget? icon; // Window icon (left side)
  final Widget? title; // Window title text
  final Color? backgroundColor; // Background color
  final Brightness? brightness; // Theme brightness (light/dark)
  final List<WindowCaptionAction> actions; // Custom action buttons
  final bool snapLayoutsEnabled; // Whether snap button is enabled

  @override
  State<SnapLayoutsCaption> createState() => _SnapLayoutsCaptionState();
}

/// State class for [SnapLayoutsCaption] that handles window management
class _SnapLayoutsCaptionState extends State<SnapLayoutsCaption>
    with WindowListener {
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color:
            widget.backgroundColor ??
            (widget.brightness == Brightness.dark
                ? const Color(0xff1C1C1C)
                : Colors.transparent),
      ),
      child: Row(
        children: [
          // Window icon
          Padding(
            padding: EdgeInsets.only(left: 6),
            child: SizedBox(
              width: 18,
              height: 18,
              child: widget.icon ?? FlutterLogo(),
            ),
          ),
          // Title area with drag-to-move functionality
          Expanded(
            child: DragToMoveArea(
              child: SizedBox(
                height: double.infinity,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 6),
                      child: DefaultTextStyle(
                        style: TextStyle(
                          color:
                              widget.brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black.withValues(alpha: 0.8956),
                          fontSize: 12,
                        ),
                        child: widget.title ?? SizedBox.shrink(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Custom action buttons
          widget.actions.isNotEmpty
              ? Padding(
                padding: EdgeInsets.only(right: 2),
                child: Row(spacing: 2, children: widget.actions),
              )
              : SizedBox.shrink(),
          // Minimize button
          WindowCaptionButton.minimize(
            brightness: widget.brightness,
            onPressed: () async {
              bool isMinimized = await windowManager.isMinimized();
              if (isMinimized) {
                windowManager.restore();
              } else {
                windowManager.minimize();
              }
            },
          ),
          // Maximize/Restore button with state tracking
          FutureBuilder<bool>(
            future: windowManager.isMaximized(),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.data == true) {
                return SnapLayoutsButton.unmaximize(
                  brightness: widget.brightness,
                  enabled: widget.snapLayoutsEnabled,
                  onPressed: () {
                    windowManager.unmaximize();
                  },
                );
              }
              return SnapLayoutsButton.maximize(
                brightness: widget.brightness,
                enabled: widget.snapLayoutsEnabled,
                onPressed: () {
                  windowManager.maximize();
                },
              );
            },
          ),
          // Close button
          WindowCaptionButton.close(
            brightness: widget.brightness,
            onPressed: () {
              windowManager.close();
            },
          ),
        ],
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
