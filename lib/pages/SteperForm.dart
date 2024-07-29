import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StepperForm extends StatefulWidget {
  const StepperForm({Key? key}) : super(key: key);

  @override
  State<StepperForm> createState() => _StepperFormState();
}

class _StepperFormState extends State<StepperForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _adharcardController = TextEditingController();
  final _pancardController = TextEditingController();
  final _addressController = TextEditingController();
  int _currentStep = 0;

  void _nextForm() {
    final personalData = {
      'firstname': _firstnameController.text,
      'lastname': _lastnameController.text,
      'mobile': _mobileController.text,
      'adharcard': _adharcardController.text,
      'pancard': _pancardController.text,
      'address': _addressController.text,
    };

    Navigator.pushNamed(
      context,
      '/equipment',
      arguments: personalData,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Personal Details',
          style: TextStyle(fontSize: 18, color: Colors.blueGrey),
        ),
        backgroundColor: Colors.yellow,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Form(
                      key: _formKey,
                      child: Stepper(
                        steps: getSteps(),
                        currentStep: _currentStep,
                        onStepContinue: () {
                          if (_currentStep == getSteps().length - 1) {
                            if (_formKey.currentState!.validate()) {
                              _nextForm();
                            }
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
                                    foregroundColor: Colors.blueGrey,
                                    backgroundColor: Colors.yellow,
                                  ),
                                ),
                              const SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: controls.onStepContinue,
                                child: Text(_currentStep == getSteps().length - 1 ? 'Next' : 'Next'),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.blueGrey,
                                  backgroundColor: Colors.yellow,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Step> getSteps() {
    return [
      Step(
        title: const Text('Name'),
        content: Column(
          children: [
            TextFormField(
              controller: _firstnameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                labelStyle: TextStyle(color: Colors.blueGrey),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow, width: 2.0),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your first name';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _lastnameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                labelStyle: TextStyle(color: Colors.blueGrey),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow, width: 2.0),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your last name';
                }
                return null;
              },
            ),
          ],
        ),
        isActive: _currentStep >= 0,
      ),
      Step(
        title: const Text('Mobile'),
        content: TextFormField(
          controller: _mobileController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: 'Mobile',
            labelStyle: TextStyle(color: Colors.blueGrey),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.yellow, width: 2.0),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your mobile number';
            }
            return null;
          },
        ),
        isActive: _currentStep >= 1,
      ),
      Step(
        title: const Text('Aadhaar Card'),
        content: TextFormField(
          controller: _adharcardController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            labelText: 'Aadhaar Card Number',
            labelStyle: TextStyle(color: Colors.blueGrey),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.yellow, width: 2.0),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your Aadhaar card number';
            }
            return null;
          },
        ),
        isActive: _currentStep >= 2,
      ),
      Step(
        title: const Text('Pan Card'),
        content: TextFormField(
          controller: _pancardController,
          decoration: InputDecoration(
            labelText: 'Pan Card Number',
            labelStyle: TextStyle(color: Colors.blueGrey),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.yellow, width: 2.0),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your Pan card number';
            }
            return null;
          },
        ),
        isActive: _currentStep >= 3,
      ),
      Step(
        title: const Text('Address'),
        content: TextFormField(
          controller: _addressController,
          decoration: InputDecoration(
            labelText: 'Address',
            labelStyle: TextStyle(color: Colors.blueGrey),
            border: OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.yellow, width: 2.0),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return 'Please enter your address';
            }
            return null;
          },
        ),
        isActive: _currentStep >= 4,
      ),
    ];
  }
}
