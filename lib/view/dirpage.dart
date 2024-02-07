// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:http/http.dart' as http;
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../constants/constants.dart';
// import '../controller/controllers.dart';
// import '../model/user_model.dart';
// import '../model/userslist_model.dart';
//
// class MyPhoneDirectory extends StatefulWidget {
//   @override
//   _MyPhoneDirectoryState createState() => _MyPhoneDirectoryState();
// }
//
// class _MyPhoneDirectoryState extends State<MyPhoneDirectory> {
//   List<UserList> contacts = [];
//   List<UserList> filteredContacts = [];
//   int currentPage = 1;
//   bool isLoading = false;
//   bool reachedEnd = false;
//
//   @override
//   void initState() {
//     super.initState();
//     userData();
//     fetchData(context.read<ControllerData>());
//   }
//
//   Future<void> fetchData(ControllerData pro) async {
//     if (isLoading || reachedEnd) return;
//
//     setState(() {
//       isLoading = true;
//     });
//
//     try {
//       final response = await http.post(
//         Uri.parse('$baseUrl/list_users'),
//         headers: {
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode({
//           "page": currentPage,
//         }),
//       );
//
//       if (response.statusCode == 200) {
//         final List<dynamic> dataList = json.decode(response.body);
//         List<UserList> newUsersList =
//         dataList.map((json) => UserList.fromJson(json)).toList();
//
//         if (newUsersList.isEmpty) {
//           reachedEnd = true;
//         } else {
//           pro.updateUsersList(newUsersList);
//           contacts = pro.usersLists;
//           filteredContacts = contacts;
//           currentPage++;
//         }
//       } else {
//         // Error in API call
//         print('Failed to load user data. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       // Exception during API call
//       print('Error: $e');
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   User? data;
//
//   Future<void> userData() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     var userdat = prefs.getString("regNo");
//     try {
//       final response = await http.post(
//         Uri.parse("$baseUrl/get_by_regno"),
//         headers: {
//           "Content-Type": "application/json",
//         },
//         body: jsonEncode(
//           {
//             "regNo": userdat,
//           },
//         ),
//       );
//
//       if (response.statusCode == 200) {
//         var user = jsonDecode(response.body);
//         box.put(0, user[0]);
//         Map<String, dynamic> profileData = box.get(0);
//         data = User.fromJson(profileData);
//         setState(() {});
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     var pro = context.read<ControllerData>();
//     contacts = pro.usersLists;
//
//     String name = "${data?.firstName ?? ""} ${data?.lastName ?? ""}";
//     var width = MediaQuery.of(context).size.width;
//     return GestureDetector(
//       onTap: () {
//         if (!FocusScope.of(context).hasPrimaryFocus) {
//           FocusScope.of(context).unfocus();
//         }
//       },
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         body: Padding(
//           padding: const EdgeInsets.all(10.0),
//           child: Column(
//             children: [
//               CircleAvatar(
//                 radius: 45.sp,
//                 backgroundColor: Colors.white,
//                 backgroundImage: data?.image != null
//                     ? MemoryImage(base64Decode(data!.image ?? ""))
//                     : const AssetImage('assets/images/man.png')
//                 as ImageProvider<Object>?,
//               ),
//               Padding(
//                 padding: EdgeInsets.only(top: 10.sp, bottom: 10.sp),
//                 child: Text(
//                   name,
//                   style: TextStyle(color: Colors.white, fontSize: 20.sp),
//                 ),
//               ),
//               TextField(
//                 onChanged: (value) {
//                   setState(() {
//                     filteredContacts = contacts;
//                     filteredContacts = contacts
//                         .where((contact) =>
//                     contact.firstName
//                         .toString()
//                         .toLowerCase()
//                         .contains(value.toLowerCase()) ||
//                         contact.phone!.contains(value) ||
//                         contact.regNo!.contains(value.toLowerCase()) ||
//                         contact.bloodGroup
//                             .toString()
//                             .contains(value.toLowerCase()) ||
//                         contact.address
//                             .toString()
//                             .contains(value.toLowerCase()))
//                         .toList();
//                   });
//                 },
//                 decoration: myInputDecoration,
//               ),
//               Expanded(
//                 child: filteredContacts.isEmpty
//                     ? Center(child: CircularProgressIndicator())
//                     : NotificationListener<ScrollNotification>(
//                   onNotification: (ScrollNotification scrollInfo) {
//                     if (!isLoading &&
//                         scrollInfo.metrics.pixels ==
//                             scrollInfo.metrics.maxScrollExtent) {
//                       fetchData(pro);
//                     }
//                     return true;
//                   },
//                   child: ListView.builder(
//                     itemCount: filteredContacts.length,
//                     itemBuilder: (context, index) {
//                       return Padding(
//                         padding: EdgeInsets.only(
//                           top: 15.sp,
//                         ),
//                         child: Container(
//                           width: width,
//                           decoration: BoxDecoration(
//                               color: Color(0xFF242424),
//                               borderRadius: BorderRadius.circular(20.sp)),
//                           child: Row(
//                             mainAxisAlignment:
//                             MainAxisAlignment.spaceBetween,
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.all(16.sp),
//                                 child: Container(
//                                   width: 70.w,
//                                   height: 80.h,
//                                   decoration: BoxDecoration(
//                                       color: Colors.grey.shade400,
//                                       borderRadius: BorderRadius.circular(10),
//                                       image: DecorationImage(
//                                         fit: BoxFit.fill,
//                                         image: filteredContacts[index].image !=
//                                             null
//                                             ? MemoryImage(base64Decode(
//                                             filteredContacts[index].image))
//                                             : const AssetImage(
//                                             'assets/images/man.png')
//                                         as ImageProvider<Object>,
//                                       )),
//                                 ),
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   showDialog(
//                                     context: context,
//                                     builder: (context) => InfoDialog(
//                                       name:
//                                       "${filteredContacts[index].firstName} ${filteredContacts[index].lastName ?? ""}",
//                                       homeAddress:
//                                       '${filteredContacts[index].address ?? ""}',
//                                       officeAddress:
//                                       '${filteredContacts[index].officeAddress ?? ""}',
//                                       clerks: [
//                                         ClerkInfo(
//                                             name: filteredContacts[index]
//                                                 .clerkName1 ??
//                                                 "",
//                                             phone: filteredContacts[index]
//                                                 .clerkPhone1 ??
//                                                 ""),
//                                         ClerkInfo(
//                                             name: filteredContacts[index]
//                                                 .clerkName2 ??
//                                                 "",
//                                             phone: filteredContacts[index]
//                                                 .clerkPhone2 ??
//                                                 ""),
//                                       ],
//                                       bloodGroup:
//                                       '${filteredContacts[index].bloodGroup ?? ""}',
//                                     ),
//                                   );
//                                 },
//                                 child: Container(
//                                   color: Color(0xFF242424),
//                                   width: width / 2,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                     CrossAxisAlignment.start,
//                                     children: [
//                                       SizedBox(
//                                         height: 30.h,
//                                       ),
//                                       Text(
//                                         "${filteredContacts[index].firstName ?? "".toString()} ${filteredContacts[index].lastName ?? "".toString()}",
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.w600,
//                                             color: Colors.white),
//                                       ),
//                                       SizedBox(
//                                         height: 5.sp,
//                                       ),
//                                       Text(
//                                         "Ph : ${filteredContacts[index].phone}",
//                                         style: TextStyle(
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 10),
//                                       ),
//                                       Text(
//                                           "Add : ${filteredContacts[index].address ?? "".toString()}",
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                           style: TextStyle(
//                                               color: Color(0xFFC6C6C6),
//                                               fontSize: 10)),
//                                       SizedBox(
//                                         height: 20.sp,
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               IconButton(
//                                 onPressed: () {
//                                   _callNumber(
//                                       "+91${filteredContacts[index].phone}");
//                                 },
//                                 icon: Icon(
//                                   Icons.call,
//                                   color: Colors.white,
//                                   size: 30.sp,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// _callNumber(String number) async {
//   number = number; // set the number here
//   bool? res = await FlutterPhoneDirectCaller.callNumber(number);
// }
//
// class InfoDialog extends StatelessWidget {
//   final String name;
//   final String homeAddress;
//   final String officeAddress;
//   final List<ClerkInfo> clerks;
//   final String bloodGroup;
//
//   InfoDialog({
//     required this.name,
//     required this.homeAddress,
//     required this.officeAddress,
//     required this.clerks,
//     required this.bloodGroup,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Personal Information'),
//       content: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           RichText(
//             text: TextSpan(
//               text: 'Name: ',
//               style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//               children: [
//                 TextSpan(
//                   text: '${name ?? "N/A"}',
//                   style: TextStyle(
//                       fontWeight: FontWeight.normal, color: Colors.black),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 8),
//           RichText(
//             text: TextSpan(
//               text: 'Home Address: ',
//               style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//               children: [
//                 TextSpan(
//                   text: '${homeAddress ?? "N/A"}',
//                   style: TextStyle(
//                       fontWeight: FontWeight.normal, color: Colors.black),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 8),
//           RichText(
//             text: TextSpan(
//               text: 'Office Address: ',
//               style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//               children: [
//                 TextSpan(
//                   text: '${officeAddress ?? "N/A"}',
//                   style: TextStyle(
//                       fontWeight: FontWeight.normal, color: Colors.black),
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 8),
//           Text('Clerks:',
//               style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
//           ...clerks.map((clerk) => Padding(
//             padding: const EdgeInsets.only(left: 16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 RichText(
//                   text: TextSpan(
//                     text: 'Clerk Name: ',
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold, color: Colors.black),
//                     children: [
//                       TextSpan(
//                         text: '${clerk.name ?? "N/A"}',
//                         style: TextStyle(
//                             fontWeight: FontWeight.normal,
//                             color: Colors.black),
//                       ),
//                     ],
//                   ),
//                 ),
//                 RichText(
//                   text: TextSpan(
//                     text: 'Clerk Phone: ',
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold, color: Colors.black),
//                     children: [
//                       TextSpan(
//                         text: '${clerk.phone ?? "N/A"}',
//                         style: TextStyle(
//                             fontWeight: FontWeight.normal,
//                             color: Colors.black),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           )),
//           SizedBox(height: 8),
//           RichText(
//             text: TextSpan(
//               text: 'Blood Group: ',
//               style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
//               children: [
//                 TextSpan(
//                   text: '${bloodGroup ?? "N/A"}',
//                   style: TextStyle(
//                       fontWeight: FontWeight.normal, color: Colors.black),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: Text('Close'),
//         ),
//       ],
//     );
//   }
// }
//
// class ClerkInfo {
//   final String? name;
//   final String? phone;
//
//   ClerkInfo({this.name, this.phone});
// }
