
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taba_app_android/services/firebase_notification.dart';
import 'package:taba_app_android/view/bottom_nav_bar.dart';
import 'package:taba_app_android/view/login.dart';

import 'controller/controllers.dart';
var  data;
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  await Hive.initFlutter(); // Initialize Hive
  final SharedPreferences prefs = await SharedPreferences.getInstance();
   data = prefs.get("regNo");
  Hive.openBox('data_box');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ControllerData())
        // ChangeNotifierProvider(create: (context) => UserPersonalData()),
      ],
      child: Consumer(
        builder: (context, value, child) => ScreenUtilInit(
          designSize: const Size(390, 862),
          // minTextAdapt: true,
          // splitScreenMode: true,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              textTheme: GoogleFonts.montserratTextTheme(
                Theme.of(context).textTheme,
              ),
              appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
            ),
            home: data != null ? BottomNavigationPage(): Login(),
          ),
        ),
      ),
    );
  }
}
