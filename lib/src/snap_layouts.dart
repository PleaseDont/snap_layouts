import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Interface for listening to Snap Layouts events
abstract mixin class SnapLayoutsListener {
  /// Triggered when window is located in a snap layouts zone
  void onSnapLayoutsLocate();

  /// Triggered when mouse hovers over a snap layouts zone
  void onSnapLayoutsHover() {}

  /// Triggered when mouse leaves a snap layouts zone
  void onSnapLayoutsLeave() {}

  /// Triggered when mouse button is pressed down in a snap layouts zone
  void onSnapLayoutsDown() {}

  /// Triggered when mouse button is released in a snap layouts zone
  void onSnapLayoutsUp() {}

  /// Triggered when a snap layouts zone is clicked
  void onSnapLayoutsClick() {}
}

/// Represents a Windows rectangle structure (RECT)
class Win32Rect {
  Win32Rect(this.left, this.top, this.right, this.bottom);
  final int left; // Left coordinate
  final int top; // Top coordinate
  final int right; // Right coordinate
  final int bottom; // Bottom coordinate
}

/// Main plugin class providing Windows 11 Snap Layouts functionality
class SnapLayouts {
  SnapLayouts._() {
    _channel.setMethodCallHandler(_methodCallHandler);
  }

  /// Singleton instance
  static final SnapLayouts instance = SnapLayouts._();

  /// Method channel for platform communication
  final _channel = const MethodChannel('snap_layouts');

  /// List of registered listeners
  final ObserverList<SnapLayoutsListener> _listeners =
      ObserverList<SnapLayoutsListener>();

  /// Handles method calls from the platform side
  Future<void> _methodCallHandler(MethodCall call) async {
    for (final listener in _listeners) {
      if (!_listeners.contains(listener)) return;

      if (call.method != 'onEvent') throw UnimplementedError();

      String eventName = call.arguments['eventName'];

      // Maps event names to corresponding handler methods
      Map<String, Function> funcMap = {
        'snap-layouts-locate': listener.onSnapLayoutsLocate,
        'snap-layouts-hover': listener.onSnapLayoutsHover,
        'snap-layouts-leave': listener.onSnapLayoutsLeave,
        'snap-layouts-down': listener.onSnapLayoutsDown,
        'snap-layouts-up': listener.onSnapLayoutsUp,
        'snap-layouts-click': listener.onSnapLayoutsClick,
      };
      funcMap[eventName]?.call();
    }
  }

  /// Adds a new event listener
  void addListener(SnapLayoutsListener listener) {
    _listeners.add(listener);
  }

  /// Removes an existing event listener
  void removeListener(SnapLayoutsListener listener) {
    _listeners.remove(listener);
  }

  /// Enables or disables the Snap Layouts feature
  Future<void> enableSnapLayouts(bool enabled) async {
    await _channel.invokeMethod('enableSnapLayouts', {'enabled': enabled});
  }

  /// Updates the rectangle area for Snap Layouts
  Future<void> updateSnapLayoutsRect({
    required int left,
    required int top,
    required int right,
    required int bottom,
  }) async {
    await _channel.invokeMethod('updateSnapLayoutsRect', {
      'left': left,
      'top': top,
      'right': right,
      'bottom': bottom,
    });
  }
}

/// Global instance of SnapLayouts
final snapLayouts = SnapLayouts.instance;
