import 'package:flutter/material.dart';

class ParametersWidget extends StatelessWidget {
  final List<Map<String, dynamic>> messages;
  final String model;
  final double temperature;
  final int maxTokens;
  final double topP;
  final bool stream;
  final Map<String, dynamic> responseFormat;
  final dynamic stop;

  ParametersWidget({
    required this.messages,
    required this.model,
    required this.temperature,
    required this.maxTokens,
    required this.topP,
    required this.stream,
    required this.responseFormat,
    required this.stop,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Messages:', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        _buildMessagesWidget(),
        SizedBox(height: 16),
        Text('Model: $model', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('Temperature:', style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: temperature,
          min: 0.0,
          max: 5.0,
          onChanged: (value) {},
        ),
        Text('Max Tokens:', style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: maxTokens.toDouble(),
          min: 0,
          max: 100,
          onChanged: (value) {},
        ),
        Text('Top P:', style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: topP,
          min: 0.0,
          max: 1.0,
          onChanged: (value) {},
        ),
        Row(
          children: [
            Text('Stream:', style: TextStyle(fontWeight: FontWeight.bold)),
            Checkbox(
              value: stream,
              onChanged: (value) {},
            ),
          ],
        ),
        Text('Response Format:', style: TextStyle(fontWeight: FontWeight.bold)),
        _buildResponseFormatWidget(),
        SizedBox(height: 8),
        Text('Stop: $stop', style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildMessagesWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: messages.map((message) {
        return ListTile(
          title: Text('${message['role']}: ${message['content']}'),
        );
      }).toList(),
    );
  }

  Widget _buildResponseFormatWidget() {
    if (responseFormat['type'] == 'json_object') {
      return Text(responseFormat.toString());
    } else {
      return Text('Unknown response format');
    }
  }
}
