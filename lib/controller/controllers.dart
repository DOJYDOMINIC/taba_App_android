import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';
import '../model/user_model.dart';
import '../model/userslist_model.dart';


class ControllerData extends ChangeNotifier {

  Map<String,dynamic> _loginResponse = {};
  List<UserList> _usersList = [];
  String _image ="";
  String _userid = '';
  String _password = '';
  var  _aboutPage = [];


  bool _notificationBadge = false;

  bool get notificationBadge => _notificationBadge;

  set notificationBadge(bool value) {
    _notificationBadge = value;
    notifyListeners();
  }

  get aboutPage => _aboutPage;

  set aboutPage(var value) {
    _aboutPage = value;
    notifyListeners();
  }

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

  String get imageData => _image;

  set imageData(String value) {
    _image = value;
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

  String _amount = '';

  String get amount => _amount;

  set amount(String value) {
    _amount = value;
  }

  List<UserList> _usersLists = [];

  List<UserList> get usersLists => _usersList;

  void updateUsersList(List<UserList> newList) {
    _usersList.addAll(newList);
    notifyListeners();
  }
}


class MyPhoneDirectoryProvider extends ChangeNotifier {

  List<UserList> contacts = [];
  List<UserList> filteredContacts = [];
  int currentPage = 1;
  bool isLoading = false;
  bool reachedEnd = false;
  bool isSearching = false;


  Future<void> fetchData() async {
    print("fetchData Called");

    if (isLoading || reachedEnd || isSearching) return;

    isLoading = true;

    try {
      final response = await http.post(Uri.parse('$baseUrl/list_users'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "page": currentPage,
        }),
      );
      if (response.statusCode == 200) {
        final List<dynamic> dataList = json.decode(response.body);
        List<UserList> newUsersList = dataList.map((json) => UserList.fromJson(json)).toList();
        if (newUsersList.isEmpty) {
          reachedEnd = true;
        } else {
          contacts.addAll(newUsersList);
          filteredContacts = contacts;
          currentPage++;
          notifyListeners();
        }
      } else {
        // Error in API call
        print('Failed to load user data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Exception during API call
      print('Error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }




  Future<void> searchData(String query) async {
    print("Search Called");

    if (query.isEmpty) {
      // If search query is empty, perform pagination with existing logic
      fetchData();
      notifyListeners();
      return;
    }

    isSearching = true;
    isLoading = true;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/search_users'),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "search": query,
        }),
      );

      if (response.statusCode == 200) {
        final List<dynamic> dataList = json.decode(response.body);
        List<UserList> searchResults =
        dataList.map((json) => UserList.fromJson(json)).toList();
        filteredContacts = searchResults;
      } else {
        // Error in API call
        print(
            'Failed to load search results. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Exception during API call
      print('Error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // Add a method to clear the search query and revert to regular pagination
  void clearSearch() {
    isSearching = false;
    filteredContacts.clear(); // Clear search results
    // currentPage = 0; // Reset page count
    reachedEnd = false; // Reset pagination flag
    fetchData(); // Fetch full data
  }
}



class UserDataProvider extends ChangeNotifier {
  User? data;

  Future<void> fetchUserData() async {
    print("fetchUserData Called");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var userdat = prefs.getString("regNo");
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/get_by_regno"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "regNo": userdat,
          },
        ),
      );

      if (response.statusCode == 200) {
        dynamic user = jsonDecode(response.body);
        box.put(0, user[0]);
        Map<String, dynamic> userdata = box.get(0);
        // Map<String, dynamic> userDat = userdata;
        data = User.fromJson(userdata);
      }
    } catch (e) {
      print('Error: $e');
    }
    notifyListeners();
  }

}


// class BadgeProvider extends ChangeNotifier {
//   int _notificationBadge = 0;
//
//   int get notificationBadge => _notificationBadge;
//
//   set notificationBadge(int value) {
//     _notificationBadge = value;
//     notifyListeners();
//   }
//
//   void incrementBadge() {
//     _notificationBadge++;
//     notifyListeners();
//   }
//
//   void clearBadge() {
//     _notificationBadge = 0;
//     notifyListeners();
//   }
// }