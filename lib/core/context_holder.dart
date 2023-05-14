import 'package:flutter/material.dart';

class ContextHolder {
  /// get current context.
  static BuildContext get currentContext {
    return key.currentContext!;
  }

  /// get current state.
  static get currentState {
    return key.currentState;
  }

  /// get current widget.
  static Widget get currentWidget {
    return key.currentWidget!;
  }

  /// get current overlay.
  // static OverlayState get currentOverlay {
  //   return key.currentState!.overlay!;
  // }

  static final navKey = GlobalKey<NavigatorState>();

  /// root app navigator key.
  /// set this key to your root app's navigatorKey.
  //static final key = GlobalKey<NavigatorState>();
  static final key = GlobalKey<ScaffoldMessengerState>();
}