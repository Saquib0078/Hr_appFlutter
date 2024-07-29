// import 'package:flutter/material.dart';
// import 'package:otpscreen/pages/Home.dart';
// import 'package:otpscreen/pages/OtpScreen.dart';
// import 'package:otpscreen/pages/SnakeButton.dart';
// import 'package:otpscreen/pages/SteperForm.dart';
// import 'package:otpscreen/pages/VerifyOtp.dart';
// import 'package:otpscreen/pages/practice.dart';
// import 'package:otpscreen/pages/EquipmentStepperForm.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
//   class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Navigation',
//       debugShowCheckedModeBanner: false,
//       initialRoute: '/form',
//       onGenerateRoute: (settings) {
//         switch (settings.name) {
//           case '/home':
//             return MaterialPageRoute(builder: (context) => HomePage());
//           case '/verify':
//           // Consider passing the mobileNumber as an argument
//             return MaterialPageRoute(builder: (context) => VerifyOtp(mobileNumber: ''));
//           case '/otp':
//           // Consider passing the mobileNumber as an argument
//             return MaterialPageRoute(builder: (context) => OtpScreen(mobileNumber: ''));
//           case '/form':
//             return MaterialPageRoute(builder: (context) => StepperForm());
//           case '/snakeButton':
//             return MaterialPageRoute(builder: (context) => SnakeAnimation());
//           case '/practice':
//             return MaterialPageRoute(builder: (context) => Practice());
//           case '/equipment':
//             final personalData = settings.arguments as Map<String, String>?;
//             if (personalData != null) {
//               return MaterialPageRoute(
//                 builder: (context) => EquipmentStepperForm(personalData: personalData),
//               );
//             }
//             // Handle the case when personalData is null
//             return MaterialPageRoute(builder: (context) => StepperForm());
//           default:
//           // Handle undefined routes
//             return MaterialPageRoute(builder: (context) => UnknownRoutePage());
//         }
//       },
//     );
//   }
// }
//
// // Add this class to handle unknown routes
// class UnknownRoutePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('404 - Page Not Found')),
//       body: Center(child: Text('The requested page does not exist.')),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:otpscreen/pages/Home.dart';
import 'package:otpscreen/pages/basic_info_page.dart';
import 'package:otpscreen/pages/experience_page.dart';
import 'package:otpscreen/pages/education_page.dart';
import 'package:otpscreen/pages/documents_page.dart';
import 'package:otpscreen/pages/employment_page.dart';
import 'package:otpscreen/pages/legal_page.dart';
import 'package:otpscreen/pages/payroll_page.dart';
import 'package:otpscreen/pages/it_access_page.dart';
import 'package:otpscreen/pages/success_page.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stepper Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StepperForm(),
    );
  }
}

class StepperForm extends StatefulWidget {
  @override
  _StepperFormState createState() => _StepperFormState();
}

class _StepperFormState extends State<StepperForm> {
  final PageController _pageController = PageController();
  final _formKey = GlobalKey<FormState>();

  int _currentStep = 0;

  Map<String, dynamic> basicInfo = {};
  Map<String, dynamic> experience = {};
  Map<String, dynamic> education = {};
  Map<String, dynamic> documents = {};
  Map<String, dynamic> employment = {};
  Map<String, dynamic> legal = {};
  Map<String, dynamic> payroll = {};
  Map<String, dynamic> itAccess = {};

  void nextPage() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_currentStep < 7) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        );
      } else {
        submitData();
      }
    }
  }

  void previousPage() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  Future<void> submitData() async {
    var uri = Uri.parse('http://62.72.31.133:8000/task/Employeeregister');
    var request = http.MultipartRequest('POST', uri);

    request.fields['basicInfo'] = jsonEncode(basicInfo);
    request.fields['experience'] = jsonEncode(experience);
    request.fields['education'] = jsonEncode(education);
    request.fields['employment'] = jsonEncode(employment);
    request.fields['legal'] = jsonEncode(legal);
    request.fields['payroll'] = jsonEncode(payroll);
    request.fields['itAccess'] = jsonEncode(itAccess);

    print('Data to be sent:');
    print('Basic Info: $basicInfo');
    print('Experience: $experience');
    print('Education: $education');
    print('Employment: $employment');
    print('Legal: $legal');
    print('Payroll: $payroll');
    print('IT Access: $itAccess');

    if (documents['aadharCard'] != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'aadharCard',
        documents['aadharCard'].path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }
    if (documents['panCard'] != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'panCard',
        documents['panCard'].path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }
    if (documents['passportPhoto'] != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'passportPhoto',
        documents['passportPhoto'].path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }
    if (documents['birthCertificate'] != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'birthCertificate',
        documents['birthCertificate'].path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    try {
      var response = await request.send();

      print('Request URL: ${request.url}');
      print('Request Fields: ${request.fields}');
      for (var file in request.files) {
        print('File field: ${file.field}');
        print('File name: ${file.filename}');
      }

      final responseBody = await response.stream.bytesToString();
      print('Response Status: ${response.statusCode}');
      print('Response Body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to register employee. Status Code: ${response.statusCode}'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stepper Form'),
      ),
      body: Form(
        key: _formKey,
        child: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            BasicInfoPage(onSaved: (data) => setState(() => basicInfo = data)),
            ExperiencePage(onSaved: (data) => setState(() => experience = data)),
            EducationPage(onSaved: (data) => setState(() => education = data)),
            DocumentsPage(onSaved: (data) => setState(() => documents = data)),
            EmploymentPage(onSaved: (data) => setState(() => employment = data)),
            LegalPage(onSaved: (data) => setState(() => legal = data)),
            PayrollPage(onSaved: (data) => setState(() => payroll = data)),
            ITAccessPage(onSaved: (data) => setState(() => itAccess = data)),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentStep > 0)
              TextButton(
                onPressed: previousPage,
                child: Text('Previous'),
              ),
            TextButton(
              onPressed: nextPage,
              child: Text(_currentStep == 7 ? 'Submit' : 'Next'),
            ),
          ],
        ),
      ),
    );
  }
}
