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
import 'constants/constants.dart';
import 'controller/controllers.dart';


main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  await Hive.initFlutter(); // Initialize Hive
  final SharedPreferences prefs = await SharedPreferences.getInstance();
 var data = prefs.get("regNo");
  Hive.openBox('data_box');
  runApp( MyApp(regNo:data));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key,this.regNo});
final regNo;
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
              textTheme: GoogleFonts.montserratTextTheme(
                Theme.of(context).textTheme,
              ),
              appBarTheme: const AppBarTheme(backgroundColor: Colors.black),
            ),
            // home: BottomNavigationPage(),
            home: regNo != null ? BottomNavigationPage() : const Login(),
          ),
        ),
      ),
    );
  }
}


class MyAppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // Code to execute before the app exits
      box.clear();
      print("Hive box cleared");
    }
  }
}
