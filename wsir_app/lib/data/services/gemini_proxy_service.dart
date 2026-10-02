import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiProxyService {
  // Use 10.0.2.2 for Android Emulator, localhost for iOS/Web
  final String _baseUrl = 'http://localhost:3000/api/v1'; 

  Future<Map<String, dynamic>> generateReply({
    required String relation,
    required String lastMessage,
    required String context,
    required List<Map<String, String>> chatHistory,
    String? imageBase64,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/generate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'relation': relation,
        'lastMessage': lastMessage,
        'context': context,
        'history': chatHistory,
        'imageBase64': ?imageBase64,
      }),
    );
    
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to generate reply from proxy: ${response.body}');
    }
  }
}
