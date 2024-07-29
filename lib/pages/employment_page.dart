import 'package:flutter/material.dart';

class EmploymentPage extends StatelessWidget {
  final Function(Map<String, dynamic>) onSaved;

  EmploymentPage({required this.onSaved});

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
                _formData['employmentJobTitle'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Department'),
              onSaved: (value) {
                _formData['department'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Start Date'),
              onSaved: (value) {
                _formData['startDate'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Employment Type'),
              onSaved: (value) {
                _formData['employmentType'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Supervisor/Manager’s Name'),
              onSaved: (value) {
                _formData['supervisorName'] = value;
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
