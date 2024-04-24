import 'package:app_agent/groqcloud_service.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [];
  
  //TODO: Fetch from groq api 
  List<String> _modelList = ['llama3-70b-8192', 'Model_02', 'Model_03'];
  late String _selectedModel; 
  @override
  void initState() {
    super.initState();
    _selectedModel = _modelList[0]; // Initialize selected model here
  }
  //--------------------------------
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
                _selectedModel = newValue ?? _selectedModel; // Ensure newValue is not null
              });
            },
            items: _modelList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          // Widget builds the messages list
          _buildMessagesList(),
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

  /* Method to build the messages list
  Widget _buildMessagesList() {
    return Expanded(
      child: ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          return MessageBubble(
            message: message,
          );
        },
      ),
    );
  }
  */

  // Method to build the messages list
Widget _buildMessagesList() {
  return FutureBuilder(
    future: _fetchMessages(), // Call the method to fetch messages
    builder: (context, AsyncSnapshot<dynamic> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (snapshot.hasError) {
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
      } else {
        // Data has been successfully fetched
        // You can process the snapshot.data here
        // For now, return a ListView.builder with dummy data
        return Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              return MessageBubble(
                message: message,
              );
            },
          ),
        );
      }
    },
  );
}

// Method to fetch messages from the API
Future<dynamic> _fetchMessages() async {
  try {
    // Instantiate GroqCloudService
    GroqCloudService groqCloudService = GroqCloudService();

    String response = groqCloudService.toString();
    _messages.add(Message(text: response, role: MessageRole.system));

    return response;
  } catch (e) {
    // Handle any errors
    return null;
  }
}





  void _handleSendMessage() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _messages.add(Message(text: _controller.text, role: MessageRole.user));
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
