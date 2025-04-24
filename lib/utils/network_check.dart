import 'dart:io';
import 'package:flutter/material.dart';

class NetworkCheck {
  /// Checks if the device has internet connectivity
  static Future<bool> isNetworkConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      debugPrint('No internet connection available');
      return false;
    }
  }
}
