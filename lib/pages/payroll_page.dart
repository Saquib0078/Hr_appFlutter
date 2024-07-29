import 'package:flutter/material.dart';

class PayrollPage extends StatelessWidget {
  final Function(Map<String, dynamic>) onSaved;

  PayrollPage({required this.onSaved});

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
              decoration: InputDecoration(labelText: 'Bank Name'),
              onSaved: (value) {
                _formData['bankName'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Bank Account Number'),
              onSaved: (value) {
                _formData['bankAccountNumber'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'IFSC Code'),
              onSaved: (value) {
                _formData['ifscCode'] = value;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Branch Address'),
              onSaved: (value) {
                _formData['branchAddress'] = value;
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
