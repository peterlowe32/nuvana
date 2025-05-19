// lib/services/verse_api.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerseApiService {
  static const String baseUrl = 'https://nuvana-api.onrender.com';

  static Future<Map<String, dynamic>> fetchReflection(String userInput) async {
    final uri = Uri.parse('$baseUrl/reflect').replace(queryParameters: {'user_input': userInput});
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch reflection');
    }
  }

  static Future<void> sendFeedback(String userId, String reference, bool helpful) async {
    final response = await http.post(
      Uri.parse('$baseUrl/feedback'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'user_id': userId,
        'reference': reference,
        'helpful': helpful,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send feedback');
    }
  }
}
