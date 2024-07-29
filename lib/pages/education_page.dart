import 'package:flutter/material.dart';

class EducationPage extends StatelessWidget {
  final Function(Map<String, dynamic>) onSaved;

  EducationPage({required this.onSaved});

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
              decoration: InputDecoration(labelText: 'School or University'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your school or university';
                }
                return null;
              },
              onSaved: (value) {
                _formData['school'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Degree'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your degree';
                }
                return null;
              },
              onSaved: (value) {
                _formData['degree'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Field of Study'),
              onSaved: (value) {
                _formData['fieldOfStudy'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'From'),
              onSaved: (value) {
                _formData['educationFrom'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'To'),
              onSaved: (value) {
                _formData['educationTo'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Languages'),
              onSaved: (value) {
                _formData['languages'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Skills'),
              onSaved: (value) {
                _formData['skills'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Websites'),
              onSaved: (value) {
                _formData['websites'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Social Network URLs'),
              onSaved: (value) {
                _formData['socialNetworks'] = value;
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
