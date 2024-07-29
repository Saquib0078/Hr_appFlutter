import 'package:flutter/material.dart';

class VerifyOtp extends StatefulWidget {
  final String mobileNumber;

  const VerifyOtp({Key? key, required this.mobileNumber}) : super(key: key);

  @override
  _VerifyOtpState createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  List<TextEditingController> otpControllers =
  List.generate(4, (index) => TextEditingController());
  String defaultOtp = '1234';
  bool verifying = false; // Flag to track verification progress

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Your OTP is $defaultOtp'),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  @override
  void dispose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void verifyOtp() {
    setState(() {
      verifying = true; // Set verifying to true to show progress indicator
    });

    // Simulate verification delay
    Future.delayed(Duration(seconds: 3), () {
      String enteredOtp =
      otpControllers.map((controller) => controller.text).join();
      if (enteredOtp == defaultOtp) {
        // Navigate to Home screen on successful OTP verification
        Navigator.pushReplacementNamed(context, '/');
      } else {
        // Show error message if OTP is incorrect
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Incorrect OTP. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() {
          verifying = false; // Reset verifying flag
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verify OTP',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(

        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'OTP is Sent to:',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              Text(
                '${widget.mobileNumber}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) => buildOtpField(index)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: verifying ? null : verifyOtp,
                child: verifying
                    ? CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                    : Text('Verify Otp'),
              ),
            ],
          ),
        ),
      ),
    );
  }



  Widget buildOtpField(int index) {
    return Container(
      width: 50,
      height: 50,
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: TextField(
        controller: otpControllers[index],
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          counter: Offstage(),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) {
          if (value.length == 1 && index < 3) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
