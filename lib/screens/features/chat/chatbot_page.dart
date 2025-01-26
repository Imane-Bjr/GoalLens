import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  _ChatBotPageState createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final TextEditingController _textController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  String _statusMessage = "";

  Future<void> _sendMessage() async {
    final String userMessage = _textController.text;
    _textController.clear();

    setState(() {
      _messages.add({'sender': 'user', 'text': userMessage});
      _isLoading = true;
      _statusMessage = "Connecting...";
    });

    final String response = await _getChatbotResponse(userMessage);

    setState(() {
      _isLoading = false;
      _statusMessage = "";
      _messages.add({'sender': 'bot', 'text': response});
    });
  }

  Future<String> _getChatbotResponse(String message) async {
    setState(() {
      _statusMessage = "Thinking...";
    });

    try {
      final Uri url = Uri.parse('http://192.168.1.15:5000/chat');
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'message': message}),
          )
          .timeout(Duration(seconds: 240));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'];
      } else {
        return 'Error: Unable to get a response from the server.';
      }
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Llama 3 Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Text(message['text']!),
                  subtitle: Text(message['sender']!),
                );
              },
            ),
          ),
          if (_isLoading) Center(child: CircularProgressIndicator()),
          if (_statusMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(_statusMessage),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(hintText: 'Enter your message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
