import 'package:flutter/material.dart';
import 'package:taba_app_android/view/notification.dart';
import 'package:taba_app_android/view/passwordreset.dart';
import 'package:taba_app_android/view/paymentpage.dart';
import 'package:taba_app_android/view/profile.dart';
import '../widgets/appdrawer.dart';
import 'dir_page.dart';

class BottomNavigationPage extends StatefulWidget {
  @override
  _BottomNavigationPageState createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int _currentIndex = 0;
  PageController _pageController = PageController(); // Add PageController

  final List<Widget> _pages = [
    MyPhoneDirectoryPage(),
    PaymentPage(),
    ProfilePage(),
  ];

  @override
  void dispose() {
    _pageController.dispose(); // Dispose PageController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(child: Text("TABA",style: TextStyle(color: Colors.white))),
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage(),));
            },
            icon: Icon(Icons.notifications_active,color: Colors.white),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: PageView( // Use PageView for swiping between pages
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index; // Update currentIndex when page changes
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage( // Animate PageView to selected page
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Payment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
