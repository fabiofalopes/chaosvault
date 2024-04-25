import 'dart:convert';
import 'package:app_agent/groq_service_keys.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';

class GroqService {
  static const String _baseUrl = 'https://api.groq.com/openai/v1';
  static const String _endpoint = 'chat/completions';
  //-----------------------------------------------------------//
  // Create a groq_service_keys.dart
  // class GroqServiceKeys {
  //   static const String groqApiKey = <YOUR_GROQ_API>;
  // }
  static const String _groqApiKey = GroqServiceKeys.groqApiKey;
  //-----------------------------------------------------------//

  Future<String> getChatCompletion(String userMessage) async {
    if (userMessage.isEmpty) {
      throw Exception('User message cannot be null or empty');
    }
    final Uri url = Uri.parse('$_baseUrl/$_endpoint');
    final Map<String, dynamic> requestBody = {
      'messages': [
        {
          'role': 'user',
          'content': userMessage,
        },
      ],
      'model': 'llama3-8b-8192',
    };

    final http.Response response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $_groqApiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(requestBody),
    );

    final _logger = Logger('GroqService');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final List<dynamic> choices = responseData['choices'];
      
      if (choices.isNotEmpty) {
        final String completionText = choices[0]['message']['content'];
        return completionText;
      } else {
        throw Exception('No completion choices received');
      }
    } else if (response.statusCode == 400) {
      _logger.severe('Error fetching chat completion: ${response.body}');
      throw Exception('Error fetching chat completion: ${response.body}');
    } else {
      _logger.severe('Failed to fetch chat completion: ${response.statusCode}');
      throw Exception('Failed to fetch chat completion: ${response.statusCode}');
    }
  }
}