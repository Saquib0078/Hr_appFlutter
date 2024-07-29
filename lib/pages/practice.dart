import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Practice extends StatefulWidget {
  const Practice({super.key});

  @override
  _PracticeState createState() => _PracticeState();
}

class _PracticeState extends State<Practice> {
  String _responseMessage = '';

  Future<void> _callApi() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:5000/test'));

    if (response.statusCode == 200) {
      setState(() {
        _responseMessage = response.body;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Response: ${response.body}')),
      );
    } else {
      setState(() {
        _responseMessage = 'Failed to load data';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Practice",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _callApi,
              child: Text('Call API'),
            ),
            SizedBox(height: 20),
            Text(
              _responseMessage,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

