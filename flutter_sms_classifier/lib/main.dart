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
    final url = Uri.parse('http://10.0.2.2:5000/classify'); 
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'message': message}),
    );
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
        title: const Text('Message Classifier',style: TextStyle(
          color: Color.fromARGB(179, 255, 255, 255)
        ),),
        backgroundColor: Color.fromARGB(227, 0, 3, 25),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(227, 0, 3, 15), Color.fromARGB(227, 25, 32, 80)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Enter your message',
                  labelStyle: TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.white24,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _classifyMessage,
                icon: Icon(Icons.send),
                label: const Text('Classify',style: TextStyle(color: Colors.white70),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 90, 86, 90), 
                  iconColor: Colors.white,// Button graycolor
                  textStyle: TextStyle(color: Colors.white), // Text color
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _classification.isEmpty ? "" : 'Classification: $_classification',
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
