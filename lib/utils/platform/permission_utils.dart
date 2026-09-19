import 'dart:io';
import 'package:flutter/services.dart';

class PermissionUtils {
  static const MethodChannel _channel = MethodChannel('com.example.eiga/permissions');

  /// Requests the user to ignore battery optimizations for this app.
  /// This is crucial for background translation services on Android.
  static Future<bool> requestIgnoreBatteryOptimizations() async {
    if (!Platform.isAndroid) return true;
    
    try {
      // Note: This requires a native implementation in MainActivity.kt
      // or using a library like permission_handler.
      // If the library is not present, this will throw a MissingPluginException.
      final bool? result = await _channel.invokeMethod('requestIgnoreBatteryOptimizations');
      return result ?? false;
    } catch (e) {
      print('PermissionUtils: Native channel not implemented yet. Error: $e');
      return false;
    }
  }

  /// Checks if the app is already ignoring battery optimizations.
  static Future<bool> isIgnoringBatteryOptimizations() async {
    if (!Platform.isAndroid) return true;
    
    try {
      final bool? result = await _channel.invokeMethod('isIgnoringBatteryOptimizations');
      return result ?? false;
    } catch (e) {
      return false;
    }
  }
}
