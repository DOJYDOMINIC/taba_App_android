import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taba_app_android/constants/constants.dart';
import '../view/bottom_nav_bar.dart';
import '../widgets/dialog.dart';
import 'package:http/http.dart' show ClientException;
import 'firebase_notification.dart';

Future<void> loginApi(BuildContext context, String regNo, String pass) async {
  FirebaseApi();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var fCMToken = prefs.getString("fCMToken");

  print("api called");

  try {
    final response = await http.post(Uri.parse("$baseUrl/login"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "regNo": regNo,
        "password": pass,
      }),
    );

    var data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      debugPrint(data.toString());
      var userData = data["user"];
      var regNo = userData["regNo"];
      var id = userData["_id"];
      prefs.setString("regNo", regNo);
      prefs.setString("id", id);
      if (fCMToken != null) {
        notificationPost(fCMToken, context);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNavigationPage(),
        ),
      );
    } else {
      if (response.statusCode == 401) {
        showPlatformDialog(context, data["message"]);
      } else if (response.statusCode == 403) {
        showPlatformDialog(context, data["message"]);
      } else {
        showPlatformDialog(context, data["message"]);
      }
    }
  } on http.ClientException catch (_) {
    showPlatformDialog(context, "Error");
  } catch (e) {
    showPlatformDialog(context, "Something went wrong");
  }
}





Future<void> notificationPost(String token, BuildContext context) async {
  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var regNo = prefs.getString("regNo");
    final response = await http.post(Uri.parse("$notificationUrl/register-device"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
          {
        "regNo": regNo,
        "token": token,
      }
      ),
    );
    print(token);

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      debugPrint(response.body.toString());
    } else {
      throw Exception('Failed to post notification: ${response.statusCode}');
    }
  } on ClientException catch (e) {
    // Handle ClientException (e.g., network error)
    print('ClientException: $e');
  } catch (e) {
    // Handle other exceptions
    print('Error posting notification: $e');
  }
}

