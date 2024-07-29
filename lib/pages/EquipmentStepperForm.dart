import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EquipmentStepperForm extends StatefulWidget {
  final Map<String, String> personalData;

  const EquipmentStepperForm({Key? key, required this.personalData}) : super(key: key);

  @override
  _EquipmentStepperFormState createState() => _EquipmentStepperFormState();
}

class _EquipmentStepperFormState extends State<EquipmentStepperForm> {
  final _formKey = GlobalKey<FormState>();
  final _laptopController = TextEditingController();
  final _phoneController = TextEditingController();
  final _accessCardController = TextEditingController();
  final _otherEquipmentController = TextEditingController();
  int _currentStep = 0;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final equipmentData = {
        'laptop': _laptopController.text,
        'phone': _phoneController.text,
        'accessCard': _accessCardController.text,
        'otherEquipment': _otherEquipmentController.text,
      };

      final combinedData = {
        ...widget.personalData,
        ...equipmentData,
      };
      print(combinedData);

      final response = await http.post(
        Uri.parse('http://192.168.1.5:3000/upload-form'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(combinedData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Form submitted successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit form!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Equipment Details',
          style: TextStyle(fontSize: 18, color: Colors.blueGrey),
        ),
        backgroundColor: Colors.yellow,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Stepper(
            steps: getSteps(),
            currentStep: _currentStep,
            onStepContinue: () {
              if (_currentStep == getSteps().length - 1) {
                _submitForm();
              } else {
                setState(() {
                  _currentStep++;
                });
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() {
                  _currentStep--;
                });
              }
            },
            controlsBuilder: (BuildContext context, ControlsDetails controls) {
              return Row(
                children: [
                  if (_currentStep != 0)
                    ElevatedButton(
                      onPressed: controls.onStepCancel,
                      child: const Text('Back'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.blueGrey, backgroundColor: Colors.yellow,
                      ),
                    ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: controls.onStepContinue,
                    child: Text(_currentStep == getSteps().length - 1 ? 'Submit' : 'Next'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.blueGrey, backgroundColor: Colors.yellow,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  List<Step> getSteps() {
    return [
      Step(
        title: const Text('Laptop Details'),
        content: TextFormField(
          controller: _laptopController,
          decoration: InputDecoration(
            labelText: 'Laptop',
            labelStyle: TextStyle(color: Colors.yellow),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.yellow, width: 2.0),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter laptop details';
            }
            return null;
          },
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: const Text('Phone Details'),
        content: TextFormField(
          controller: _phoneController,
          decoration: InputDecoration(
            labelText: 'Phone',
            labelStyle: TextStyle(color: Colors.yellow),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.yellow, width: 2.0),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter phone details';
            }
            return null;
          },
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: const Text('Access Card'),
        content: TextFormField(
          controller: _accessCardController,
          decoration: InputDecoration(
            labelText: 'Access Card',
            labelStyle: TextStyle(color: Colors.yellow),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.yellow, width: 2.0),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter access card details';
            }
            return null;
          },
        ),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: const Text('Other Equipment'),
        content: TextFormField(
          controller: _otherEquipmentController,
          decoration: InputDecoration(
            labelText: 'Other Equipment',
            labelStyle: TextStyle(color: Colors.yellow),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.yellow, width: 2.0),
            ),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter other equipment details';
            }
            return null;
          },
        ),
        isActive: _currentStep >= 3,
      ),
    ];
  }
}
