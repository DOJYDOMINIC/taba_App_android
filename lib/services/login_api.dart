import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taba_app_android/constants/constants.dart';
import '../controller/controllers.dart';
import '../view/bottom_nav_bar.dart';
import '../widgets/dialog.dart';

Future<void> loginApi(BuildContext context, String regNo, String pass) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "regNo": regNo,
        // "regNo": "K/69/2002",
        "password": pass,
        // "password": "1234",
      }),
    );
    prefs.clear();
    if (response.statusCode == 200) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var pro = Provider.of<ControllerData>(context, listen: false);
      var data = jsonDecode(response.body);
      pro.userid = data["user"]["regNo"];
      var id = data["user"]["_id"];
      prefs.setString("regNo", pro.userid);
      prefs.setString("id", id);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigationPage(),
          ));
    } else {
      var data = jsonDecode(response.body);
      showPlatformDialog(context, data["message"]);
      // print(response.body);
      // Handle error appropriately (e.g., show an error message to the user)
      print("Error - Status Code: ${response.statusCode}, ${response.body}");
    }
  } catch (e) {
    // showPlatformDialog(context, "something went wrong");
    debugPrint("Exception during API call: $e");
    // Handle exceptions (e.g., network issues, timeout) appropriately
  }
}
