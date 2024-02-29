import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:taba_app_android/view/passwordreset.dart';
import 'package:taba_app_android/view/register.dart';
import '../constants/constants.dart';
import '../controller/controllers.dart';
import '../services/firebase_notification.dart';
import '../services/login_api.dart';
import '../widgets/text_field.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key, this.data}) : super(key: key);
final data;
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    FirebaseApi();
  }

  var name ="";

  Future<void> fetchName(String userid) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/get_by_regno"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "regNo": userid,
          },
        ),
      );
      name = "";
      setState(() {
      });
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        name = data[0]["firstName"];
        setState(() {});
      } else {
        print(response.body.toString());
      }
    } catch (e) {
      print("Exception during API call: $e");
    }
  }

  bool _obscureText = true;
  TextEditingController userid = TextEditingController();
  TextEditingController password = TextEditingController();

  final _userIdFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  // final focusNode = FocusNode();

  String? validateString(String value) {
    final RegExp regex = RegExp(r'^K\/\d+\/\d{4}$');
    if (!regex.hasMatch(value)) {
      return 'Invalid format. Format like "K/000/2008"';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var pro = Provider.of<ControllerData>(context);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    double top = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () {
          if (!FocusScope.of(context).hasPrimaryFocus) {
            FocusScope.of(context).unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: top * 2),
                    child: Container(
                      height: height * .45,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/images/net.png'),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: top * 3,
                    left: 20,
                    child: const Text(
                      "Welcome",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Positioned(
                    top: top * 5,
                    left: 20,
                    child: const Text(
                      "Contact us easy\nwith no Limits call",
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: Color.fromRGBO(179, 179, 179, 1),
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                  child: Text("${name?? ""}",style: TextStyle(color: Colors.white),overflow:TextOverflow.ellipsis,)),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Form(
                      key: _userIdFormKey,
                      child: TextFieldOne(
                        readonly: false,
                        hinttext: "Reg ID",
                        controller: userid,
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
                        onchange: (value) {
                          fetchName(userid.text);
                          _userIdFormKey.currentState!.validate();
                          pro.userid = value;
                          // debugPrint(userid.text);
                        },
                        obsecuretxt: false,
                      ),
                    ),
                    SizedBox(
                      height: height * .005,
                    ),
                    Form(
                      key: _passwordFormKey,
                      child: TextFieldOne(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          return null; // Return null if the input is valid
                        },
                        readonly: false,
                        hinttext: "Password",
                        controller: password,
                        onchange: (value) {
                          _passwordFormKey.currentState!.validate();
                          pro.password = value;
                        },
                        obsecuretxt: _obscureText,
                        sufix: IconButton(
                          icon: Icon(
                              _obscureText
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.grey),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * .05,
                    ),
                    SizedBox(
                      height: 50,
                      width: height,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0))),
                        ),
                        onPressed: () async{
                          if (_userIdFormKey.currentState!.validate() &&
                              _passwordFormKey.currentState!.validate()) {
                            // If the form is valid, call the loginApi function
                           await loginApi(context, userid.text, password.text);
                          }
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: width * .10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PasswordResetPage(),
                                  ));
                            },
                            child: Text(
                              "ForgotPassword",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            )),
                        Text(
                          'Don’t have an account ? ',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Registration(),
                              ),
                            );
                          },
                          child: Text("SignUp",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
