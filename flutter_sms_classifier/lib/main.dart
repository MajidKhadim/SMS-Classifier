import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MessageClassificationScreen(),
    );
  }
}

class MessageClassificationScreen extends StatefulWidget {
  @override
  _MessageClassificationScreenState createState() => _MessageClassificationScreenState();
}

class _MessageClassificationScreenState extends State<MessageClassificationScreen> {
  final TextEditingController _controller = TextEditingController();
  String _classification = '';

  Future<void> _classifyMessage() async {
    final message = _controller.text;
    final url = Uri.parse('http://10.0.2.2:5000/classify');  // Update with your server address if needed
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'message': message}),
    );
    print("request sent");
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      setState(() {
        _classification = responseData['classification'] == 1 ? 'Spam' : 'Ham';
      });
    } else {
      throw Exception('Failed to classify message');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Classifier'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Enter your message',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _classifyMessage,
              child: const Text('Classify'),
            ),
            const SizedBox(height: 20),
            Text(
              _classification.isEmpty ? "" : 'Classification: $_classification',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
