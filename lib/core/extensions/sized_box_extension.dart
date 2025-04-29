import 'package:flutter/material.dart';

/// Extension methods for numbers to create SizedBox instances
extension SizedBoxExtension on num {
  /// Creates a SizedBox with this value as height
  SizedBox height() {
    return SizedBox(height: toDouble());
  }

  /// Creates a SizedBox with this value as width
  SizedBox width() {
    return SizedBox(width: toDouble());
  }
}
