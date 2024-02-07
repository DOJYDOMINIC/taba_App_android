import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../constants/constants.dart';
import '../controller/controllers.dart';
import '../model/imagemodel.dart';
import '../model/userslist_model.dart';

class MyPhoneDirectoryPage extends StatefulWidget {
  @override
  _MyPhoneDirectoryState createState() => _MyPhoneDirectoryState();
}

class _MyPhoneDirectoryState extends State<MyPhoneDirectoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<UserDataProvider>().fetchUserData();
    context.read<MyPhoneDirectoryProvider>().fetchData();
    // context.read<MyPhoneDirectoryProvider>().fetchImageData();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer2<MyPhoneDirectoryProvider, UserDataProvider>(
      builder: (context, phoneDirProvider, userDataProvider, child) {

        // print("amount :  ${userDataProvider.data?.annualFee?? "0"}");
        // final paginationData = Provider.of<PaginationData>(context);
        var pro = context.read<ControllerData>();
        List<UserList> contacts = pro.usersLists;
        pro.amount = userDataProvider.data?.annualFee ?? "0";

        String name = userDataProvider.data?.firstName ?? "";
        var width = MediaQuery.of(context).size.width;

        return GestureDetector(
          onTap: () {
            if (!FocusScope.of(context).hasPrimaryFocus) {
              FocusScope.of(context).unfocus();
            }
          },
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 45.sp,
                    backgroundColor: Colors.white,
                    backgroundImage: userDataProvider.data?.image != null
                        ? MemoryImage(
                            base64Decode(userDataProvider.data!.image ?? ""))
                        : const AssetImage('assets/images/man.png')
                            as ImageProvider<Object>?,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.sp, bottom: 10.sp),
                    child: Text(
                      name,
                      style: TextStyle(color: Colors.white, fontSize: 20.sp),
                    ),
                  ),
                  TextField(
                    onChanged: (value) {
                      if (value.isEmpty) {
                        phoneDirProvider.isSearching = false;
                        // phoneDirProvider.fetchData();
                        // phoneDirProvider.filteredContacts = contacts;
                      } else {
                        phoneDirProvider.isSearching = true;
                        phoneDirProvider.searchData(value);
                      }
                    },
                    decoration: myInputDecoration,
                  ),
                  Expanded(
                    child: phoneDirProvider.filteredContacts.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : NotificationListener<ScrollNotification>(
                            onNotification: (ScrollNotification scrollInfo) {
                              if (!phoneDirProvider.isLoading &&
                                  scrollInfo.metrics.pixels ==
                                      scrollInfo.metrics.maxScrollExtent) {
                                phoneDirProvider.fetchData();
                              }
                              return true;
                            },
                            child: ListView.builder(
                              itemCount:
                                  phoneDirProvider.filteredContacts.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    top: 15.sp,
                                  ),
                                  child: Container(
                                    width: width,
                                    decoration: BoxDecoration(
                                        color: Color(0xFF242424),
                                        borderRadius:
                                            BorderRadius.circular(20.sp)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Padding(
                                        //   padding: EdgeInsets.all(16.sp),
                                        //   child: Container(
                                        //     width: 70.w,
                                        //     height: 80.h,
                                        //     decoration: BoxDecoration(
                                        //         color: Colors.grey.shade400,
                                        //         borderRadius:
                                        //             BorderRadius.circular(10),
                                        //         image: DecorationImage(
                                        //           fit: BoxFit.fill,
                                        //           image: phoneDirProvider
                                        //                       .filteredContacts[
                                        //                           index]
                                        //                       .image !=
                                        //                   null
                                        //               ? MemoryImage(base64Decode(
                                        //                   phoneDirProvider
                                        //                       .filteredContacts[
                                        //                           index]
                                        //                       .image))
                                        //               : const AssetImage(
                                        //                       'assets/images/man.png')
                                        //                   as ImageProvider<
                                        //                       Object>,
                                        //         ),
                                        //     ),
                                        //   ),
                                        // ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20),
                                          child: GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) => InfoDialog(
                                                  name:
                                                      "${phoneDirProvider.filteredContacts[index].firstName}",
                                                  homeAddress:
                                                      '${phoneDirProvider.filteredContacts[index].address ?? ""}',
                                                  officeAddress:
                                                      '${phoneDirProvider.filteredContacts[index].officeAddress ?? ""}',
                                                  clerks: [
                                                    ClerkInfo(
                                                        name: phoneDirProvider
                                                                .filteredContacts[
                                                                    index]
                                                                .clerkName1 ??
                                                            "",
                                                        phone: phoneDirProvider
                                                                .filteredContacts[
                                                                    index]
                                                                .clerkPhone1 ??
                                                            ""),
                                                    ClerkInfo(
                                                        name: phoneDirProvider
                                                                .filteredContacts[
                                                                    index]
                                                                .clerkName2 ??
                                                            "",
                                                        phone: phoneDirProvider
                                                                .filteredContacts[
                                                                    index]
                                                                .clerkPhone2 ??
                                                            ""),
                                                  ],
                                                  bloodGroup:
                                                      '${phoneDirProvider.filteredContacts[index].bloodGroup ?? ""}',
                                                ),
                                              );
                                            },
                                            child: Container(
                                              color: Color(0xFF242424),
                                              width: 250.sp,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 30.h,
                                                  ),
                                                  Text(
                                                    "${phoneDirProvider.filteredContacts[index].firstName ?? ""}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(
                                                    height: 5.sp,
                                                  ),
                                                  Text(
                                                    "Ph : ${phoneDirProvider.filteredContacts[index].phone}",
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 10),
                                                  ),
                                                  Text(
                                                      "Add : ${phoneDirProvider.filteredContacts[index].address ?? "".toString()}",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xFFC6C6C6),
                                                          fontSize: 10)),
                                                  SizedBox(
                                                    height: 20.sp,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(right: 20),
                                          child: IconButton(
                                            onPressed: () {
                                              _callNumber(
                                                  "${phoneDirProvider.filteredContacts[index].phone}");
                                            },
                                            icon: Icon(
                                              Icons.call,
                                              color: Colors.white,
                                              size: 30.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  _callNumber(String number) async {
    number = number; // set the number here
    await FlutterPhoneDirectCaller.callNumber(number);
  }
}

class InfoDialog extends StatelessWidget {
  final String name;
  final String homeAddress;
  final String officeAddress;
  final List<ClerkInfo> clerks;
  final String bloodGroup;

  InfoDialog({
    required this.name,
    required this.homeAddress,
    required this.officeAddress,
    required this.clerks,
    required this.bloodGroup,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Expanded(child: Text('Personal Information')),
              CircleAvatar(
                radius: 40.sp,
                backgroundColor: Colors.white,
                backgroundImage: const AssetImage('assets/images/man.png')
                as ImageProvider<Object>?,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    '${name}',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black,fontSize: 16,),
                  ),
                ),
              ),
            ],
          ),
          Divider(thickness: 2,)
        ],
      ),
      content: Container(
        height: 300.sp,
        child: Scrollbar(
          thumbVisibility: true,
          interactive: true,
          thickness: 5,
          radius: const Radius.circular(2),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        'Name:  ',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(
                            '${name}',
                            style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Home \nAddress: ',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Expanded(
                        child: Text(
                          '${homeAddress}',
                          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        'Office \nAddress: ',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      Expanded(
                        child: Text(
                          '${officeAddress ?? "N/A"}',
                          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),
                  Text('Clerks:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  ...clerks.map((clerk) => Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SelectableText.rich(
                              TextSpan(
                                text: 'Name: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                children: [
                                  TextSpan(
                                    text: '${clerk.name ?? "N/A"}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            SelectableText.rich(
                               TextSpan(
                                text: 'Phone: ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, color: Colors.black),
                                children: [
                                  TextSpan(
                                    text: '${clerk.phone ?? "N/A"}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black),
                                  ),

                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                          ],
                        ),
                      )),
                  SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      text: 'Blood Group: ',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                      children: [
                        TextSpan(
                          text: '${bloodGroup ?? "N/A"}',
                          style: TextStyle(
                              fontWeight: FontWeight.normal, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Close'),
        ),
      ],
    );
  }
}

class ClerkInfo {
  final String? name;
  final String? phone;

  ClerkInfo({this.name, this.phone});
}
