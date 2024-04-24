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
  final String _baseUrl = 'https://api.groqcloud.com/v1';
  String details = 'API key not found';

  GroqCloudService() {
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    _apiKey = (await getApiKey())!;
    details = _apiKey.isEmpty ? 'API key not found' : 'API key found';
  }


  Future<http.Response> fetchAlbum() {
    return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));
  }



}
