import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taba_app_android/constants/constants.dart';
import '../view/bottom_nav_bar.dart';
import '../view/login.dart';
import '../view/profile.dart';



class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Drawer(
      width: width / 1.5,
      backgroundColor: Colors.black,
      child:Container(
      decoration: BoxDecoration(
      border: Border.all(
        color: Colors.white, // Set border color
        width: .5, // Set border width
    ),),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('TABA',
                  style: TextStyle(color: Colors.white)),
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
                  MaterialPageRoute(builder: (context) => BottomNavigationPage()),
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
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
              leading: Icon(
                Icons.info_outline,
                color: Colors.white, // Set the icon color to white
              ),
            ),
            ListTile(
              title: Text('Logout', style: TextStyle(color: Colors.white)),
              onTap: () async {
                final SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
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
    );
  }
}
