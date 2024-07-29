import 'package:flutter/material.dart';

class ExperiencePage extends StatelessWidget {
  final Function(Map<String, dynamic>) onSaved;

  ExperiencePage({required this.onSaved});

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
              decoration: InputDecoration(labelText: 'Job Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your job title';
                }
                return null;
              },
              onSaved: (value) {
                _formData['jobTitle'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Company'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your company';
                }
                return null;
              },
              onSaved: (value) {
                _formData['company'] = value;
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
