import 'package:flutter/material.dart';

class LegalPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onSaved;

  LegalPage({required this.onSaved});

  @override
  _LegalPageState createState() => _LegalPageState();
}

class _LegalPageState extends State<LegalPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'signedContract': false,
    'signedNDA': false,
    'handbookAcknowledgment': false,
    'taxForms': false,
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CheckboxListTile(
              title: Text('Signed Employment Contract'),
              value: _formData['signedContract'],
              onChanged: (bool? value) {
                setState(() {
                  _formData['signedContract'] = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Non-Disclosure Agreement'),
              value: _formData['signedNDA'],
              onChanged: (bool? value) {
                setState(() {
                  _formData['signedNDA'] = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Employee Handbook Acknowledgment'),
              value: _formData['handbookAcknowledgment'],
              onChanged: (bool? value) {
                setState(() {
                  _formData['handbookAcknowledgment'] = value ?? false;
                });
              },
            ),
            CheckboxListTile(
              title: Text('Tax Forms'),
              value: _formData['taxForms'],
              onChanged: (bool? value) {
                setState(() {
                  _formData['taxForms'] = value ?? false;
                });
              },
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  widget.onSaved(_formData);
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
