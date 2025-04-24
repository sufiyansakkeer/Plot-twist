import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../domain/repositories/plot_twist_repository.dart';
import '../../state/api_service.dart';

class PlotTwistRepositoryImpl implements PlotTwistRepository {
  final ApiService apiService;

  PlotTwistRepositoryImpl(this.apiService);

  @override
  Future<String> generateContent(String inputText, String format) async {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      debugPrint('GEMINI_API_KEY is not set or is empty.');
      throw Exception('GEMINI_API_KEY is missing.');
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
        return response.text!;
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
}
