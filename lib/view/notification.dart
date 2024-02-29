import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/constants.dart';
import 'bottom_nav_bar.dart';
import 'package:http/http.dart' as http;

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Future<List<Map<String, dynamic>>> notificationFuture;

  @override
  void initState() {
    super.initState();
    notificationFuture = getNotification();
  }

  Future<List<Map<String, dynamic>>> getNotification() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var regNo = prefs.getString("regNo")!;
    print(regNo);
    // Define your API endpoint URL
    try {
      // Send GET request
      var response = await http.post(
        Uri.parse("$notificationUrl/get-message"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "regNo": regNo,
        }),
      );
      // Check the response status
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body) as List;
        return responseData.cast<Map<String, dynamic>>();
      } else {
        // Request failed
        print('Error: ${response.reasonPhrase}');
        throw Exception('Failed to load notifications');
      }
    } catch (e) {
      // Exception occurred
      print('Error: $e');
      throw Exception('Failed to load notifications');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _launchURL();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text("Official",
            //     style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.bold)),
            Image.asset(
              'assets/images/whatsapp.png',
              width: 30.sp, // Adjust width as needed
              height: 30.sp, // Adjust height as needed
            ),
            // Text("Group",
            //     style: TextStyle(fontSize: 6.sp, fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BottomNavigationPage()),
            );
          },
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: Colors.white),
        ),
        centerTitle: true,
        title: Text(
          "Notification",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: notificationFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Map<String, dynamic>> notifications = snapshot.data!;
            // Reverse the list here
            notifications = notifications.reversed.toList();
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.only(bottom: 5, left: 10, right: 10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.grey.shade900,
                  child: GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: "${notifications[index]["title"].toString()}\n${notifications[index]["body"].toString()}"));
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(milliseconds:500 ),content: Text("Copied"),backgroundColor: Colors.green,));
                    },
                    child: ListTile(
                      title: Text(
                        notifications[index]["title"].toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.6.h,
                        ),
                      ),
                      subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ReadMoreText(
                                notifications[index]["body"].toString(),
                                style: TextStyle(
                                  color: Color(0xFF9B9B9B),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  height: 1.6.h,
                                ),
                                trimLines: 2,
                                colorClickableText: Color(0xFFC67C4E),
                                trimMode: TrimMode.Line,
                                trimLength: 10,
                                trimCollapsedText: 'Read More',
                                trimExpandedText: 'Show Less',
                                moreStyle: TextStyle(
                                  color: Color(0xFFC67C4E),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                  height: 0.12.h,
                                ),
                              ),
                          ]),
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  _launchURL() async {
    final Uri url =
        Uri.parse('https://chat.whatsapp.com/IufAfSK4PhvJKiKiQ3Cn12');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch url');
    }
  }
}
