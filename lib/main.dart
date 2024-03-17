import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taba_app_android/services/firebase_notification.dart';
import 'package:taba_app_android/view/bottom_nav_bar.dart';
import 'package:taba_app_android/view/login.dart';
import 'constants/constants.dart';
import 'controller/controllers.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  await Hive.initFlutter(); // Initialize Hive
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var data = prefs.get("regNo");
  print(data);
  Hive.openBox('data_box');
  runApp(MyApp(regNo: data));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.regNo});

  final regNo;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    validateUser();
  }

  var userValid = "true";
  Future<void> validateUser() async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/check-user"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "regNo": widget.regNo,
          },
        ),
      );
      var data = jsonDecode(response.body);
      print(data);
      if (response.statusCode == 200) {
        userValid == "true";
        setState(() {});
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.clear();
        box.clear();
        userValid == "false";
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login(),));
        setState(() {});
      }
    } catch (e) {
      print("Exception during API call: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ControllerData()),
        ChangeNotifierProvider(create: (_) => MyPhoneDirectoryProvider()),
        ChangeNotifierProvider(create: (_) => UserDataProvider()),
      ],
      child: Consumer(
        builder: (context, value, child) => ScreenUtilInit(
          designSize: const Size(390, 862),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'RobotFont',
              // textTheme: GoogleFonts.montserratTextTheme(Theme.of(context).textTheme,),
              appBarTheme: const AppBarTheme(backgroundColor: Colors.black),

            ),
            // home: DetailsPage(),
            home: userValid != "true" || widget.regNo == null|| widget.regNo == "" ? Login() :BottomNavigationPage(),
          ),
        ),
      ),
    );
  }
}

