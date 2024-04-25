import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OpenAIExample extends StatefulWidget {
  @override
  _OpenAIExampleState createState() => _OpenAIExampleState();
}

class _OpenAIExampleState extends State<OpenAIExample> {
  Future<String> fetchCompletion() async {
    final response = await http.post(
      Uri.parse('https://api.groqcloud.com/v1'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer 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',
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
      return jsonDecode(response.body)['choices'][0]['delta']['content'];
    } else {
      throw Exception('Failed to fetch completion');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('OpenAI Example'),
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: fetchCompletion(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Text(snapshot.data ?? '');
            }
          },
        ),
      ),
    );
  }
}
