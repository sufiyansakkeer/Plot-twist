import 'package:flutter/material.dart';

/// Extension methods for double to create SizedBox instances
extension DoubleExtensions on num {
  /// Creates a SizedBox with this value as height
  SizedBox height() => SizedBox(height: toDouble());

  /// Creates a SizedBox with this value as width
  SizedBox width() => SizedBox(width: toDouble());
}
