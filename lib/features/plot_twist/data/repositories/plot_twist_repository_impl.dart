import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../domain/repositories/plot_twist_repository.dart';
import '../models/plot_twist_history_model.dart';

class PlotTwistRepositoryImpl implements PlotTwistRepository {
  final Connectivity _connectivity = Connectivity();
  final String _historyBoxName = 'plot_twist_history';
  final Uuid _uuid = Uuid();

  PlotTwistRepositoryImpl();

  @override
  Future<String> generateContent(String inputText, String format) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      debugPrint('GEMINI_API_KEY is not set or is empty.');
      throw Exception('GEMINI_API_KEY is missing.');
    }

    // Check internet connection
    final connectivityResult = await _connectivity.checkConnectivity();
    if (!connectivityResult.contains(ConnectivityResult.mobile) &&
        !connectivityResult.contains(ConnectivityResult.wifi) &&
        !connectivityResult.contains(ConnectivityResult.ethernet)) {
      throw Exception('No internet connection');
    }

    // Initialize the Generative Model
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );

    final prompt = _formatPrompt(inputText, format);
    final content = [Content.text(prompt)];

    try {
      // Call the Gemini API
      final response = await model.generateContent(content);

      // Extract the generated text
      if (response.text != null) {
        final generatedContent = response.text!;
        // Automatically save to history
        await saveToHistory(inputText, generatedContent, format);
        return generatedContent;
      } else {
        debugPrint('Gemini response text was null.');
        // Check for blocked content or other issues
        if (response.promptFeedback?.blockReason != null) {
          debugPrint(
            'Content blocked: ${response.promptFeedback!.blockReason}',
          );
          throw Exception(
            'Content generation failed due to safety settings: ${response.promptFeedback!.blockReason}',
          );
        }
        return 'No content generated or content was blocked.';
      }
    } catch (e) {
      debugPrint('Error calling Gemini API: $e');
      if (e.toString().contains('No internet connection')) {
        throw Exception(
          'No internet connection. Please check your connection.',
        );
      }
      throw Exception('Failed to generate content using Gemini: $e');
    }
  }

  String _formatPrompt(String inputText, String format) {
    switch (format) {
      case 'Movie Script':
        return 'Write a movie script scene based on this premise: $inputText';
      case 'Rap Verse':
        return 'Write a rap verse about: $inputText';
      case 'Shakespearean Monologue':
        return 'Write a Shakespearean monologue about: $inputText';
      default:
        return 'Generate creative content based on this input: $inputText';
    }
  }

  @override
  Future<void> saveToHistory(String inputText, String generatedContent, String format) async {
    final box = await Hive.openBox<PlotTwistHistoryModel>(_historyBoxName);
    
    final historyItem = PlotTwistHistoryModel(
      id: _uuid.v4(),
      inputText: inputText,
      generatedContent: generatedContent,
      format: format,
      createdAt: DateTime.now(),
    );
    
    await box.add(historyItem);
    await box.close();
  }

  @override
  Future<List<PlotTwistHistoryModel>> getHistoryItems() async {
    final box = await Hive.openBox<PlotTwistHistoryModel>(_historyBoxName);
    final items = box.values.toList();
    await box.close();
    
    // Sort by date, newest first
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    
    return items;
  }

  @override
  Future<void> deleteHistoryItem(String id) async {
    final box = await Hive.openBox<PlotTwistHistoryModel>(_historyBoxName);
    
    final indexToDelete = box.values.toList().indexWhere((item) => item.id == id);
    if (indexToDelete != -1) {
      await box.deleteAt(indexToDelete);
    }
    
    await box.close();
  }

  @override
  Future<void> clearAllHistory() async {
    final box = await Hive.openBox<PlotTwistHistoryModel>(_historyBoxName);
    await box.clear();
    await box.close();
  }
}
