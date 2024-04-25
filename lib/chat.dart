import 'package:flutter/material.dart';
import 'package:app_agent/groq_service.dart';
import 'package:logging/logging.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  late String _selectedModel;
  List<String> _modelList = ['llama3-70b-8192', 'Model_02', 'Model_03'];

  @override
  void initState() {
    super.initState();
    _selectedModel = _modelList[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Dashboard'),
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            value: _selectedModel,
            onChanged: (String? newValue) {
              setState(() {
                _selectedModel = newValue ?? _selectedModel;
              });
            },
            items: _modelList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return MessageBubble(
                  message: message,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Type a message...',
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: _handleSendMessage,
                  child: Text('Send'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSendMessage() async {
    if (_controller.text.isNotEmpty) {
      final completion = await GroqService().getChatCompletion(_controller.text);
      setState((){
        try {
          _messages.add(Message(text: _controller.text, role: MessageRole.user));
          if (completion.isNotEmpty) {
            _messages.add(Message(text: completion, role: MessageRole.system));
          } else {
            _messages.add(Message(text: 'No completion received', role: MessageRole.system));
          } 
          //_messages.add(Message(text: completion, role: MessageRole.system));
        } catch (e) {
          // log error
          Logger('Chat').severe('Error sending message: $e');
        // Handle error (e.g., show error message to the user)
      }  
      _controller.clear();
      });
    }
  }
}

enum MessageRole {
  user,
  system,
}

class Message {
  final String text;
  final MessageRole role;

  Message({required this.text, required this.role});
}

class MessageBubble extends StatelessWidget {
  final Message message;

  MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            message.role == MessageRole.user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: message.role == MessageRole.user ? Colors.blue : Colors.green,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              message.text,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
