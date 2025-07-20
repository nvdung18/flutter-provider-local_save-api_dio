import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:logger/web.dart';

class ErrorHandler {
  Future<void> initialize() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      _handleFlutterError(details);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      _handlePlatformError(error, stack);
      return true;
    };
  }

  void _handleFlutterError(FlutterErrorDetails details) {
    Logger().e('🔥 Flutter Error: ${details.exception}');
    Logger().e('Stack: ${details.stack}');
    // TODO: Gửi lên server, Crashlytics, log file...
  }

  void _handlePlatformError(Object error, StackTrace stack) {
    Logger().e('🚀 Platform Error: $error');
    Logger().e('Stack: $stack');
    // TODO: Gửi lên server, Crashlytics, log file...
  }

  void handleZoneError(Object error, StackTrace stack) {
    Logger().e('💥 Zone Error: $error');
    Logger().e('Stack: $stack');
    // TODO: Gửi lên server hoặc Crashlytics
  }
}
