import 'package:flutter/material.dart';
import '../services/verse_api.dart';

class ReflectPage extends StatefulWidget {
  @override
  _ReflectPageState createState() => _ReflectPageState();
}

class _ReflectPageState extends State<ReflectPage> {
  String userInput = '';
  Map<String, dynamic>? response;
  bool isLoading = false;

  void handleFetch() async {
    setState(() => isLoading = true);
    response = await VerseApiService.fetchReflection(userInput);
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nuvana Reflection")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(labelText: "What's on your heart?"),
              onChanged: (val) => userInput = val,
            ),
            ElevatedButton(
              onPressed: handleFetch,
              child: Text("Reflect"),
            ),
            if (isLoading) CircularProgressIndicator(),
            if (response != null) ...[
              Text("📖 ${response!['reference']}", style: TextStyle(fontWeight: FontWeight.bold)),
              Text("“${response!['verse']}”", style: TextStyle(fontStyle: FontStyle.italic)),
              Text("🧠 ${response!['reflection']}"),
            ]
          ],
        ),
      ),
    );
  }
}
