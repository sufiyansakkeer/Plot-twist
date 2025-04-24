import 'dart:developer';

import 'api_service.dart';
import 'package:flutter/foundation.dart';

class AppState extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  String inputText = '';
  String selectedFormat = 'Movie Script';
  bool isLoading = false;
  String outputText = '';

  void updateInputText(String text) {
    inputText = text;
    notifyListeners();
  }

  void updateSelectedFormat(String? format) {
    if (format != null) {
      selectedFormat = format;
      notifyListeners();
    }
  }

  Future<void> generateOutput() async {
    if (inputText.isEmpty) return;

    isLoading = true;
    notifyListeners();

    try {
      outputText = await _apiService.generateContent(inputText, selectedFormat);
    } catch (e) {
      log(e.toString(), name: "Generate Error");
      outputText = 'Error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
