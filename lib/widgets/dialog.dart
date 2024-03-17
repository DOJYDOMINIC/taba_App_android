import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../view/passwordreset.dart';

void showPlatformDialog(BuildContext context, String text ) {
  if (Platform.isIOS) {
    // iOS dialog
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Alert'),
          content: Text(text),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                if(text == "Please reset your password to continue"){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PasswordResetPage(),));
                }else{
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  } else if (Platform.isAndroid) {
    // Android dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text(text),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                if(text == "Please reset your password to continue"){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PasswordResetPage(),));
                }else{
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  } else {
    // Unsupported platform
    print('Unsupported platform');
  }
}
