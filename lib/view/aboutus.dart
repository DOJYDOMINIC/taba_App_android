import 'dart:convert';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../constants/constants.dart';

class DetailsPage extends StatefulWidget {
  @override
  State<DetailsPage> createState() => _DetailsPageState();
}



class _DetailsPageState extends State<DetailsPage> {

  @override
  void initState(){
    super.initState();
    aboutUs();
  }
var data;
  Future<void> aboutUs() async {
    try {
      final response = await http.get(Uri.parse('$adminBaseUrl/aboutus'),headers: {
        "Content-Type": "application/json",
      },);
      if (response.statusCode == 200) {
         data = jsonDecode(response.body);
         print(data[0]["description"]);
        setState(() {
        });
      } else {
        // Handle non-200 status code, if needed
        print("Failed to load about us: ${response.statusCode}");
      }
    } catch (e) {
     print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
          Navigator.pop(context);
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ,))
        }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
        title: Text(
          'The Alleppey Bar Association',
          style: TextStyle(color: Colors.white,fontSize: 16.sp,fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child:data == null ? Center(child: CircularProgressIndicator()): Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              color: Colors.white,
              child: Image.memory(
                base64Decode(data[0]["image"]),
                width: 90.sp, // Adjust the width as needed
                height: 90.sp, // Adjust the height as needed
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Since 1908 | Registered in 1941',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: Colors.white, // Set text color to white
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              data[0]["description"],
              style: TextStyle(
                fontSize: 16,
                color: Colors.white, // Set text color to white
              ),
            ),
            SizedBox(height: 24.0),
            Text(
              'Address:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Set text color to white
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              data[0]["address"].toString(),
              style: TextStyle(
                fontSize: 16,
                color: Colors.white, // Set text color to white
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Contact:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Set text color to white
              ),
            ),
            SizedBox(height: 15),
            GestureDetector(
              onTap: (){
                _callNumber(data[0]["phone"].toString());
              },
              child: Row(
                children: [
                  Icon(
                    Icons.phone,
                    color: Colors.white, // Set icon color to white
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    data[0]["phone"].toString(),
                    style: TextStyle(
                      color: Colors.white, // Set text color to white
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Icon(
                  Icons.email,
                  color: Colors.white, // Set icon color to white
                ),
                SizedBox(width: 8.0),
                GestureDetector(
                  onTap: (){
                    _launchEmail(data[0]["email"].toString());
                  },
                  child: Text(
                    data[0]["email"].toString(),
                    style: TextStyle(
                      color: Colors.blueAccent, // Set text color to white
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  void _callNumber(String number) async {
    if(number.length > 9){
      await FlutterPhoneDirectCaller.callNumber(number);
    }
  }

  // Function to launch email client
  void _launchEmail(email) async {
    if (await canLaunchUrlString('mailto:$email')) {
      await launchUrlString('mailto:$email');
    } else {
      throw 'Could not launch email';
    }
  }
}
