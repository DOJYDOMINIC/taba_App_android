import 'package:flutter/material.dart';
import 'package:taba_app_android/view/notification.dart';
import 'package:taba_app_android/view/paymentpage.dart';
import 'package:taba_app_android/view/profile.dart';
import '../widgets/appdrawer.dart';
import 'dirpage2.dart';
import 'dirpage3.dart';


class BottomNavigationPage extends StatefulWidget {
  @override
  _BottomNavigationPageState createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    MyPhoneDirectoryPage(),
    PaymentPage(),
    ProfilePage()

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(child: Text("TABA",style: TextStyle(color: Colors.white))),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage(),));
          }, icon: Icon(Icons.notifications_active,color: Colors.white,))
        ],
      ),
      drawer: AppDrawer(),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        // elevation: 4,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: Colors.black.withOpacity(.9),

        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
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

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('Home Page'),
//     );
//   }
// }
