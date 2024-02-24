import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taba_app_android/view/passwordreset.dart';
import 'package:taba_app_android/view/register.dart';
import '../controller/controllers.dart';
import '../services/login_api.dart';
import '../widgets/text_field.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
  }

  bool _obscureText = true;
  TextEditingController userid = TextEditingController();
  TextEditingController password = TextEditingController();

  final _userIdFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  // final focusNode = FocusNode();

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
                        onchange: (value) {
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
                        onPressed: () {
                          loginApi(context, userid.text, password.text);
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
                      height: width * .15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                          TextButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordResetPage(),));
                          }, child: Text("ForgotPassword",style: TextStyle(color: Colors.white,fontSize: 10),)),
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
                          child: Text("SignUp",style: TextStyle(color: Colors.white,fontSize: 10)),
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
