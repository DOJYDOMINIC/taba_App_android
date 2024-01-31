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
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  final _enroll = GlobalKey<FormState>();

  bool isDateValid(String date) {
    try {
      DateTime parsedDate = DateFormat('dd-MM-yyyy').parseStrict(date);
      return parsedDate != null;
    } catch (e) {
      return false;
    }
  }

  var datas;
  String enrolldate = "";
  bool _obscurepassword = true;
  bool _obscureconfirmpassword = true;

  final useridkey = GlobalKey<FormState>();
  final phonekey = GlobalKey<FormState>();
  final passwordkey = GlobalKey<FormState>();
  final confirmpasswordkey = GlobalKey<FormState>();

  TextEditingController regNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  TextEditingController enrolldatecontroller = TextEditingController();

  String? _regNo;
  String? _password;
  String? _confirmpassword;

User? userData;
  fetchData() {
    try {
      // Your asynchronous code, e.g., making an HTTP request
      Map<String,dynamic> result = box.get(0);
      userData = User.fromJson(result);
      print(userData?.firstName);
      // addData();
    } catch (error) {debugPrint("Hive: $error");}
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    // double top = MediaQuery.of(context).padding.top;


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
                child: Column(
                  children: [
                    TextFieldOne(
                      hinttext: "Reg No",
                      controller: regNumber,
                      onchange: (value) {
                        setState(() {
                          _regNo = value;
                          userData?.regNo = value;
                          // debugPrint(_phoneNumber);
                        });
                      },
                      obsecuretxt: false,
                      readonly: false,
                    ),
                    Form(
                      key: _enroll,
                      child: TextFieldOne(
                        hinttext: "Enrollment date",
                        keytype: TextInputType.number,
                        controller: enrolldatecontroller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enrollment date is required';
                          }

                          if (!isDateValid(value)) {
                            return 'Invalid date format. Please enter a valid date (dd-MM-yyyy)';
                          }

                          return null; // Return null if the validation is successful
                        },
                        onchange: (value) {
                          _enroll.currentState!.validate();
                          enrolldate = value;
                          userData?.enrollmentDate = value;


                          // setState(() {});
                        },
                        obsecuretxt: false,
                        sufix: IconButton(
                          onPressed: () async {
                            _enroll.currentState!.validate();
                            var datePicked =
                                await DatePicker.showSimpleDatePicker(
                              context,
                              firstDate: DateTime(1900),
                              dateFormat: "dd-MM-yyyy",
                              locale: DateTimePickerLocale.en_us,
                              looping: true,
                            );
                            if (datePicked != null) {
                              enrolldate = DateFormat('dd-MM-yyyy').format(datePicked);
                              enrolldatecontroller.text = enrolldate;
                              userData?.enrollmentDate = enrolldate;

                            }
                            setState(() {

                            });
                          },
                          icon: Icon(
                            Icons.calendar_month,
                            color: Colors.grey,
                          ),
                        ),
                        readonly: false,
                      ),
                    ),
                    TextFieldOne(
                      hinttext: "Password",
                      controller: password,
                      onchange: (value) {
                        setState(() {
                          _password = value;
                          // debugPrint(_phoneNumber);
                        });
                      },
                      validator: (value) {},
                      obsecuretxt: _obscurepassword,
                      sufix: IconButton(
                        icon: Icon(
                          _obscurepassword
                              ? Icons.visibility
                              : Icons.visibility_off,
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
                      hinttext: "Confirm Password",
                      readonly: false,
                      controller: confirmpassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'confirm password is empty.';
                        }
                        return null;
                      },
                      onchange: (value) {
                        setState(() {
                          _confirmpassword = value;
                          // debugPrint(_phoneNumber);
                        });
                      },
                      obsecuretxt: _obscureconfirmpassword,
                      sufix: IconButton(
                        icon: Icon(
                          _obscureconfirmpassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureconfirmpassword = !_obscureconfirmpassword;
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
                                      borderRadius:
                                          BorderRadius.circular(18.0))),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                        ),
                        onPressed: () async {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          var regNo = prefs.getString("regNo");
                          prefs.clear();
                          if (regNo == null) {
                            box.clear();
                          }
                       Map<String,dynamic> collectedData= {
                         "regNo": regNumber.text,
                         "password": password.text,
                         "enrollmentDate": enrolldatecontroller.text,
                       };

                          print(collectedData["regNo"]);


                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProfilePage(item : collectedData),
                              ));

                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //       builder: (context) => ProfilePage(),
                          //     ));
                          // if (useridkey.currentState!.validate() ||
                          //     phonekey.currentState!.validate() ||
                          //     passwordkey.currentState!.validate() ||
                          //     confirmpasswordkey.currentState!.validate()) {
                          // verifyOtp(phoneNumber!);
                          // UploadImage();
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
                          'Alredy have an account ? ',
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
                                    builder: (context) => Login()));
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
            ],
          ),
        ),
      ),
    );
  }
}
