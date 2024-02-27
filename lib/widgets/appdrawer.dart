import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taba_app_android/constants/constants.dart';
import '../view/aboutpage.dart';
import '../view/bottom_nav_bar.dart';
import '../view/login.dart';
import '../view/passwordreset.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        if (!FocusScope.of(context).hasPrimaryFocus) {
          FocusScope.of(context).unfocus();
        }
      },

      child: Drawer(
        width: width / 1.5,
        backgroundColor: Colors.black,
        child: Container(
          decoration: BoxDecoration(color: Colors.grey.shade900),
          child: ListView(
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                child: Text('TABA', style: TextStyle(color: Colors.white)),
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
              ),
              ListTile(
                title: Text('Home', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BottomNavigationPage()),
                  );
                },
                leading: Icon(
                  Icons.home,
                  color: Colors.white, // Set the icon color to white
                ),
              ),
              ListTile(
                title: Text('About', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutPage()),
                  );
                },
                leading: Icon(
                  Icons.info_outline,
                  color: Colors.white, // Set the icon color to white
                ),
              ),
              // SizedBox(height: 100.sp,),
              // ListTile(
              //   title: Text('Reset Password', style: TextStyle(color: Colors.white)),
              //   onTap: () {
              //     Navigator.pop(context); // Close the drawer
              //     Navigator.pushReplacement(
              //       context,
              //       MaterialPageRoute(builder: (context) => PasswordResetPage()),
              //     );
              //   },
              //   leading: Icon(
              //     Icons.refresh_sharp,
              //     color: Colors.white, // Set the icon color to white
              //   ),
              // ),
              SizedBox(height: MediaQuery.of(context).size.height-400,),
              ListTile(
                title: Text('Logout', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove("regNo");
                  box.clear();
                  // Handle logout logic
                  Navigator.pop(context); // Close the drawer
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.white, // Set the icon color to white
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
