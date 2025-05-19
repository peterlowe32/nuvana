import 'dart:convert';
import 'package:http/http.dart' as http;

class ReflectService {
  static const String _baseUrl = 'https://nuvana-1.onrender.com';

  static Future<Map<String, dynamic>> getReflection(String userInput) async {
    final uri = Uri.parse('$_baseUrl/reflect?user_input=${Uri.encodeComponent(userInput)}');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get reflection: ${response.statusCode}');
    }
  }
}
