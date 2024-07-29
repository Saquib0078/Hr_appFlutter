import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Successful'),
      ),
      body: Center(
        child: Text(
          'Your registration was successful!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
