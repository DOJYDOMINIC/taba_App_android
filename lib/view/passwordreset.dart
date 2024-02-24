import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
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

  @override
  Widget build(BuildContext context) {
    Future<void> restPassword() async {
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
          showPlatformDialog(context, data["message"]);
        } else {
          var data = jsonDecode(response.body);
          showPlatformDialog(context, data["message"]);
          // print(response.body);
          // Handle error appropriately (e.g., show an error message to the user)
          print(
              "Error - Status Code: ${response.statusCode}, ${response.body}");
        }
      } catch (e) {
        // showPlatformDialog(context, "something went wrong");
        debugPrint("Exception during API call: $e");
        // Handle exceptions (e.g., network issues, timeout) appropriately
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
            leading: IconButton(onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),));
            }, icon:Icon(Icons.arrow_back,color: Colors.white,)),
            title: Text(
              "Reset Password",
              style: TextStyle(color: Colors.white),
            )),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 50.sp,
              ),
              TextField(
                style: TextStyle(color: Colors.white),
                controller: regNo,
                decoration: InputDecoration(
                  labelText: 'Register Number',
                  labelStyle: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                style: TextStyle(color: Colors.white),
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'New Password',
                    labelStyle: TextStyle(color: Colors.white)
                    // hintText: 'Enter your new password',
                    ),
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white, // Background color
                  onPrimary: Colors.black, // Text color
                  padding: EdgeInsets.all(16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  // Handle password reset logic here
                  // String phone = phoneController.text;
                  // String newPassword = newPasswordController.text;
                  restPassword();
                  regNo.clear();
                  newPasswordController.clear();
                  // Implement your password reset logic (e.g., API call, validation)
                },
                child: Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
