import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../model/userslist_model.dart';




class ControllerData extends ChangeNotifier {

  Map<String,dynamic> _loginResponse = {};
  List<UserList> _usersList = [];
  String _userid = '';
  String _password = '';


  Map<String,dynamic> get loginResponse => _loginResponse;

  set loginResponse(Map<String,dynamic> value) {
    _loginResponse = value;
    notifyListeners();
  }

  List<UserList> get usersList => _usersList;

  set usersList(List<UserList> value) {
    _usersList = value;
    notifyListeners();
  }
// Getter and setter for email
  String get userid => _userid;

  set userid(String value) {
    _userid = value;
    notifyListeners();
  }

  // Getter and setter for password
  String get password => _password;

  set password(String value) {
    _password = value;
    notifyListeners();
  }



}
