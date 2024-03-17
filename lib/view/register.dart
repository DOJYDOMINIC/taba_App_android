import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taba_app_android/constants/constants.dart';
import 'package:taba_app_android/model/user_model.dart';
import 'package:taba_app_android/view/profile.dart';
import 'package:taba_app_android/widgets/text_field.dart';
import 'login.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController regNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  TextEditingController enrolldatecontroller = TextEditingController();

  String? _regNo;
  String? _password;
  String? _confirmpassword;
  String? enrolldate;

  bool _obscurepassword = true;
  bool _obscureconfirmpassword = true;

  User? userData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
     box.clear();
    } catch (error) {
      debugPrint("Error: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

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
                  Container(
                    height: height / 2.5,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/net1.png'),
                      ),
                    ),
                  ),
                  Positioned(
                    top: height / 9,
                    left: 20,
                    child: const Text(
                      " Sign Up",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  Positioned(
                    top: height / 6,
                    left: 20,
                    child: const Text(
                      'Contact us easy\nwith no Limits call',
                      style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: Color.fromRGBO(179, 179, 179, 1),
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFieldOne(
                        labeltext: rollNumber,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Reg ID is required';
                          }
                          final RegExp regex = RegExp(r'^K\/\d+\/\d{4}$');
                          if (!regex.hasMatch(value)) {
                            return 'Invalid format. Format like "K/000/2008"';
                          }
                          return null;
                        },
                        controller: regNumber,
                        onchange: (value) {
                          setState(() {
                            _regNo = value;
                            userData?.regNo = value;
                          });
                        },
                        obsecuretxt: false,
                        readonly: false,
                      ),
                      TextFieldOne(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Enrollment date is empty.';
                          }
                          return null;
                        },
                        ontap: () async {
                          var datePicked =
                          await DatePicker.showSimpleDatePicker(
                            context,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                            dateFormat: "dd/MM/yyyy",
                            locale: DateTimePickerLocale.en_us,
                            looping: true,
                          );
                          if (datePicked != null) {
                            enrolldate =
                                DateFormat('dd/MM/yyyy').format(datePicked);
                            enrolldatecontroller.text = enrolldate!;
                            userData?.enrollmentDate = enrolldate!;
                            setState(() {});
                          }
                        },
                        labeltext: "Enrollment Date",
                        keytype: TextInputType.number,
                        controller: enrolldatecontroller,
                        onchange: (value) {
                          enrolldate = value;
                          userData?.enrollmentDate = value;
                        },
                        obsecuretxt: false,
                        sufix: IconButton(
                          onPressed: () async {
                            var datePicked =
                            await DatePicker.showSimpleDatePicker(
                              context,
                              firstDate: DateTime(1900),
                              dateFormat: "dd/MM/yyyy",
                              locale: DateTimePickerLocale.en_us,
                              looping: true,
                            );
                            if (datePicked != null) {
                              enrolldate =
                                  DateFormat('dd/MM/yyyy').format(datePicked);
                              enrolldatecontroller.text = enrolldate!;
                              userData?.enrollmentDate = enrolldate!;
                              setState(() {});
                            }
                          },
                          icon: Icon(
                            Icons.calendar_month,
                            color: Colors.grey,
                          ),
                        ),
                        readonly: true,
                      ),
                      TextFieldOne(
                        labeltext: "Password",
                        controller: password,
                        onchange: (value) {
                          setState(() {
                            _password = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is empty.';
                          }
                          if (password.text.length < 6 ) {
                            return 'Password must be at least 6 characters.';
                          }
                          return null;
                        },
                        obsecuretxt: _obscurepassword,
                        sufix: IconButton(
                          icon: Icon(
                            _obscurepassword
                                ? Icons.visibility_off :Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurepassword = !_obscurepassword;
                            });
                          },
                        ),
                        readonly: false,
                      ),
                      TextFieldOne(
                        labeltext: "Confirm Password",
                        readonly: false,
                        controller: confirmpassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirm password is empty.';
                          }
                          if (_password != value) {
                            return "Passwords don't match";
                          }
                          return null;
                        },
                        onchange: (value) {
                          setState(() {
                            _confirmpassword = value;
                          });
                        },
                        obsecuretxt: _obscureconfirmpassword,
                        sufix: IconButton(
                          icon: Icon(
                            _obscureconfirmpassword
                                ? Icons.visibility_off :Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureconfirmpassword =
                              !_obscureconfirmpassword;
                            });
                          },
                        ),
                      ),
                      SizedBox(
                        height: height * .03,
                      ),
                      SizedBox(
                        height: 50.h,
                        width: height,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                            ),
                            backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.clear();
                              var regNo = prefs.getString("regNo");
                              if (regNo == null) {
                                box.clear();

                              }
                              Map<String, dynamic> collectedData = {
                                "regNo": _regNo,
                                "password": password.text,
                                "enrollmentDate": enrolldatecontroller.text,
                              };
                              print(collectedData.toString());
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProfilePage(item: collectedData),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * .02,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account ? ',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.sp,
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                              );
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
