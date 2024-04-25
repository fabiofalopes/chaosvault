import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

Future<String?> getApiKey() async {
  try {
    final envContents = await rootBundle.loadString('.env');
    final apiKeyLine = envContents.split('\n').firstWhere(
      (line) => line.startsWith('GROQCLOUD_API_KEY='),
      orElse: () => '',
    );
    return apiKeyLine.substring('GROQCLOUD_API_KEY='.length);
  } catch (e) {
    print('Error loading API key: $e');
    return null;
  }
}

class GroqCloudService {
  late String _apiKey = '';
  // final String _baseUrl = 'https://api.groqcloud.com/v1';
  String details = 'API key not found';

  GroqCloudService() {
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    _apiKey = (await getApiKey())!;
    details = _apiKey.isEmpty ? 'API key not found' : 'API key found';
  }


  Future<String> fetchCompletion() async {
  final response = await http.post(
    Uri.parse('https://api.groqcloud.com/v1'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_apiKey',
    },
    body: jsonEncode({
      'model': 'llama3-8b-8192',
      'messages': [
        {'role': 'user', 'content': 'Olá how como puedes ajudar?'}
      ],
      'temperature': 1,
      'max_tokens': 1024,
      'top_p': 1,
      'stream': true,
      'stop': null,
    }),
  );

  if (response.statusCode == 200) {
    // If the server returns a 200 OK response, then parse the JSON.
    return response.body;
  } else {
    // If the server did not return a 200 OK response, then throw an exception.
    throw Exception('Failed to load data');
  }
}



}
