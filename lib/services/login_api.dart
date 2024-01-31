import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taba_app_android/constants/constants.dart';
import '../controller/controllers.dart';
import '../view/bottom_nav_bar.dart';


Future<void> loginApi(BuildContext context, String regNo, String pass) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "regNo": regNo,
        "password": pass,
      }),
    );

    if (response.statusCode == 200) {
      var pro = Provider.of<ControllerData>(context, listen: false);
     var data = jsonDecode(response.body);
      print(data.toString());
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("regNo",regNo);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigationPage(),
          ));
    } else {
      // Handle error appropriately (e.g., show an error message to the user)
      print("Error - Status Code: ${response.statusCode}, ${response.body}");
    }
  } catch (e) {
    debugPrint("Exception during API call: $e");
    // Handle exceptions (e.g., network issues, timeout) appropriately
  }
}
