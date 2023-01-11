import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GPT-3 Fine Tuned Model Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'GPT-3 Fine Tuned Model Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textController = TextEditingController();
  late String _text;
  String _output = 'Result will be shown here';
  final _url = "https://api.openai.com/v1/completions";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GPT-3 Fine-Tune Model Demo')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Write your prompt:",
                style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _textController,
              onChanged: (value) {
                _text = value;
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _sendToOpenAi();
              },
              child: const Text('Send'),
            ),
            const SizedBox(height: 30.0),
            Container(
                padding: const EdgeInsets.all(15),
                alignment: Alignment.center,
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 1.5),
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(10)),
                child: Text(_output))
          ],
        ),
      ),
    );
  }

  void _sendToOpenAi() async {
    try {
      var response = await http.post(Uri.parse(_url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': "Bearer <YOUR_TOKEN>"
          },
          body: jsonEncode({
            "prompt": "$_text ->",
            "model": "<YOUR_MODEL>",
            "stop": "[END]",
          }));
      final result = jsonDecode(response.body);
      setState(() {
        _output = "Answer:\n${result["choices"][0]["text"]}";
      });
    } catch (_) {
      print(_.toString());
    }
  }
}
