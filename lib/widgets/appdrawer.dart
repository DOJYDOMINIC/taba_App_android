import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taba_app_android/controller/controllers.dart';
import '../view/aboutpage.dart';
import '../view/aboutus.dart';
import '../view/bottom_nav_bar.dart';
import '../view/login.dart';
import '../view/passwordreset.dart';

class AppDrawer extends StatefulWidget {
  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!FocusScope.of(context).hasPrimaryFocus) {
          FocusScope.of(context).unfocus();
        }
      },
      child: Drawer(
        width: MediaQuery.of(context).size.width / 1.5,
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
                 Provider.of<MyPhoneDirectoryProvider>(context,listen: false).isSearching = false;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BottomNavigationPage()),
                  );
                },
                leading: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
              ),
              ListTile(
                title: Text('Committee', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Committee()),
                  );
                },
                leading: Icon(
                  Icons.supervised_user_circle_outlined,
                  color: Colors.white,
                ),
              ),
              ListTile(
                title: Text('About Us', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Provider.of<MyPhoneDirectoryProvider>(context,listen: false).isSearching = false;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailsPage()),
                  );
                },
                leading: Icon(
                  Icons.info,
                  color: Colors.white,
                ),
              ),
              ListTile(
                title: Text('Reset Password', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => PasswordResetPage()),
                  );
                },
                leading: Icon(
                  Icons.refresh_sharp,
                  color: Colors.white,
                ),
              ),
              ListTile(
                title: Text('Logout', style: TextStyle(color: Colors.white)),
                onTap: () async {
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  // prefs.remove("regNo");
                  prefs.clear();
                  // Handle logout logic
                  // Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                leading: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
