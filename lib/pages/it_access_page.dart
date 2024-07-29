import 'package:flutter/material.dart';

class ITAccessPage extends StatelessWidget {
  final Function(Map<String, dynamic>) onSaved;

  ITAccessPage({required this.onSaved});

  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Preferred Username'),
              onSaved: (value) {
                _formData['preferredUsername'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Device Requirements'),
              onSaved: (value) {
                _formData['deviceRequirements'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Software Requirements'),
              onSaved: (value) {
                _formData['softwareRequirements'] = value;
              },
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  onSaved(_formData);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
