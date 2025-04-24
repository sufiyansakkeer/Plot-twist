import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GeminiApiService {
  final String? apiKey;
  final String baseUrl = 'https://generativelanguage.googleapis.com/v1beta';

  GeminiApiService() : apiKey = dotenv.env['GEMINI_API_KEY'] {
    if (apiKey == null) {
      debugPrint('Warning: GEMINI_API_KEY not found in .env file');
    }
  }

  Future<Map<String, dynamic>> generateContent(String prompt) async {
    if (apiKey == null) {
      throw Exception(
        'API key not configured. Please add GEMINI_API_KEY to .env file',
      );
    }

    try {
      final response = await http.post(
        Uri.parse(
          '$baseUrl/models/gemini-1.5-flash-latest:generateContent?key=$apiKey',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              'parts': [
                {'text': prompt},
              ],
            },
          ],
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to generate content: ${response.body}');
      }
    } on SocketException catch (e) {
      throw Exception(
        'Network error: Please check your internet connection. Details: $e',
      );
    } catch (e) {
      throw Exception('Failed to generate content using Gemini: $e');
    }
  }
}
