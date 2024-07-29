import 'package:flutter/material.dart';

class BasicInfoPage extends StatelessWidget {
  final Function(Map<String, dynamic>) onSaved;

  BasicInfoPage({required this.onSaved});

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
              decoration: InputDecoration(labelText: 'Given Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your given name';
                }
                return null;
              },
              onSaved: (value) {
                _formData['givenName'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Family Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your family name';
                }
                return null;
              },
              onSaved: (value) {
                _formData['familyName'] = value;
              },
            ),
            // Add more fields as needed
            Spacer(),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  onSaved(_formData);
                  // Move to next step
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
