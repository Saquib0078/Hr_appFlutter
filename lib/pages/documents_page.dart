import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DocumentsPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onSaved;

  DocumentsPage({required this.onSaved});

  @override
  _DocumentsPageState createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {
    'aadharCard': null,
    'panCard': null,
    'passportPhoto': null,
    'birthCertificate': null,
  };

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(String key) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _formData[key] = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePicker('aadharCard', 'Upload Aadhar Card'),
              _buildImagePicker('panCard', 'Upload PAN Card'),
              _buildImagePicker('passportPhoto', 'Upload Passport Size Photo'),
              _buildImagePicker('birthCertificate', 'Upload Birth Certificate'),
              SizedBox(height: 20),
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
      ),
    );
  }

  Widget _buildImagePicker(String key, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        SizedBox(height: 8),
        _formData[key] != null
            ? Image.file(_formData[key], height: 100, width: 100, fit: BoxFit.cover)
            : Text('No image selected'),
        ElevatedButton(
          onPressed: () => _pickImage(key),
          child: Text('Choose Image'),
        ),
        SizedBox(height: 16),
      ],
    );
  }
}
