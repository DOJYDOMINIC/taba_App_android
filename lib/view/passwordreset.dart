import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';
import '../widgets/dialog.dart';
import 'login.dart';

class PasswordResetPage extends StatefulWidget {
  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  TextEditingController regNo = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _passwordVisibility = false;
  bool _confirmpasswordVisibility = false;

  @override
  Widget build(BuildContext context) {
    Future<void> resetPassword() async {
      try {
        final response = await http.post(
          Uri.parse("$baseUrl/reset-password"),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode({
            "regNo": regNo.text.toString(),
            "newPassword": newPasswordController.text.toString(),
          }),
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(data["message"]),
              duration: Duration(seconds: 1),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Login(data: regNo.text)),
          );
        } else {
          var data = jsonDecode(response.body);
          showPlatformDialog(context, data["message"]);
          print(
              "Error - Status Code: ${response.statusCode}, ${response.body}");
        }
      } catch (e) {
        debugPrint("Exception during API call: $e");
      }
    }

    return GestureDetector(
      onTap: () {
        if (!FocusScope.of(context).hasPrimaryFocus) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () async {
              SharedPreferences prefs =
              await SharedPreferences.getInstance();
              prefs.clear();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          title: Text(
            "Reset Password",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 100.sp,
                  ),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: regNo,
                    decoration: InputDecoration(
                      labelText: 'Register Number',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Reg ID is required';
                      }
                      // Define your regular expression pattern
                      final RegExp regex = RegExp(r'^K\/\d+\/\d{4}$');
                      // Check if the input value matches the pattern
                      if (!regex.hasMatch(value)) {
                        return 'Invalid format. Format should be like "K/333/2008"';
                      }
                      return null; // Return null if the input is valid
                    },
                  ),
                  SizedBox(height: 16.0.h),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: newPasswordController,
                    obscureText: _passwordVisibility,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          _passwordVisibility = !_passwordVisibility;
                          setState(() {});
                        },
                        icon: _passwordVisibility == false
                            ? Icon(Icons.visibility, color: Colors.white)
                            : Icon(Icons.visibility_off, color: Colors.white),
                      ),
                      labelText: 'New Password',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'New Password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0.h),
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: confirmPasswordController,
                    obscureText: _confirmpasswordVisibility,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          _confirmpasswordVisibility = !_confirmpasswordVisibility;
                          setState(() {});
                        },
                        icon: _confirmpasswordVisibility == false
                            ? Icon(Icons.visibility, color: Colors.white)
                            : Icon(Icons.visibility_off, color: Colors.white),
                      ),
                      labelText: 'Confirm Password',
                      labelStyle: TextStyle(color: Colors.white),
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm Password is required';
                      }
                      if (value != newPasswordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 100.0.h),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.black,
                      padding: EdgeInsets.all(16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        resetPassword();
                      }
                    },
                    child: Text('Reset Password'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
