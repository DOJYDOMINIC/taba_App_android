import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/constants.dart';
import '../controller/controllers.dart';
import '../model/userslist_model.dart';

class MyPhoneDirectoryPage extends StatefulWidget {
  @override
  _MyPhoneDirectoryState createState() => _MyPhoneDirectoryState();
}

class _MyPhoneDirectoryState extends State<MyPhoneDirectoryPage> {
  TextEditingController _searchData = TextEditingController();

  @override
  void initState() {
    super.initState();
    if(_searchData.text.isEmpty){
      Provider.of<MyPhoneDirectoryProvider>(context,listen: false).isSearching = false;
    }
    final userProvider = context.read<UserDataProvider>();
    final phoneDirProvider = context.read<MyPhoneDirectoryProvider>();
    userProvider.fetchUserData();
    phoneDirProvider.fetchData();

  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MyPhoneDirectoryProvider, UserDataProvider>(
      builder: (context, phoneDirProvider, userDataProvider, child) {
        var pro = context.read<ControllerData>();
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
                    radius: 48.sp,
                    backgroundColor: Colors.grey,
                    child: CircleAvatar(
                      radius: 45.sp,
                      backgroundColor: Colors.white,
                      backgroundImage: userDataProvider.data?.image != null
                          ? MemoryImage(
                          base64Decode(userDataProvider.data!.image ?? ""))
                          : const AssetImage('assets/images/man.png')
                      as ImageProvider<Object>? ??
                          AssetImage('assets/images/man.png'),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10.sp, bottom: 10.sp, left: 20, right: 20),
                    child: Text(
                      name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _searchData,
                      onChanged: (value){
                        if (value.length <=1) {
                          phoneDirProvider.isSearching = false;
                          phoneDirProvider.fetchData();
                        }else{
                          phoneDirProvider.isSearching = true;
                          phoneDirProvider.searchData(value);
                        }
                      },
                      onSubmitted: (value) {
                        if (value.isEmpty) {
                          phoneDirProvider.isSearching = false;
                          phoneDirProvider.fetchData();
                        } else if(value.length >=0) {
                          phoneDirProvider.isSearching = true;
                          phoneDirProvider.searchData(value);
                        }
                      },
                      decoration: myInputDecoration,
                    ),
                  ),
                  Expanded(
                    child: phoneDirProvider.filteredContacts.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (!phoneDirProvider.isLoading &&
                            scrollInfo.metrics.pixels ==
                                scrollInfo.metrics.maxScrollExtent &&
                            !phoneDirProvider.reachedEnd) {
                          phoneDirProvider.fetchData();
                        }
                        return true;
                      },
                      child: RefreshIndicator(
                        onRefresh: () async {
                          context.read<MyPhoneDirectoryProvider>().isSearching = false;
                          phoneDirProvider.fetchData();
                          },
                        child: Scrollbar(
                          thumbVisibility: true,
                          thickness: 3,
                          child: ListView.builder(
                            itemCount: phoneDirProvider.filteredContacts.length + (phoneDirProvider.reachedEnd ? 0 : 1),
                            itemBuilder: (context, index) {
                              if (index < phoneDirProvider.filteredContacts.length) {
                                return _buildContactItem(phoneDirProvider.filteredContacts[index]);
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: _searchData.text.isEmpty
                                        ? CircularProgressIndicator()
                                        : null,
                                  ),
                                );
                              }
                            },
                          ),
                        )
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

  Widget _buildContactItem(UserList contact) {
    return Padding(
      padding: EdgeInsets.only(top: 15.sp),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF242424),
          borderRadius: BorderRadius.circular(20.sp),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 10, top: 10, bottom: 10),
              child: GestureDetector(
                onTap: () {
                  _showLargerImage(contact);
                },
                child: Container(
                  width: 70.w,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: contact.image != null
                          ? MemoryImage(base64Decode(contact.image))
                          : AssetImage('assets/images/man.png')
                      as ImageProvider<Object>,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                _showContactInfoDialog(contact);
              },
              child: Container(
                color: Color(0xFF242424),
                width: 180.sp,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30.h),
                    Text(
                      "${contact.firstName ?? ""}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5.sp),
                    Text(contact.nickName == null || contact.nickName == ""  ?"(No Nick Name)": "(${contact.nickName ?? ""})",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5.sp),
                    Text(
                      "Ph : ${contact.phone}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 20.sp),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: IconButton(
                onPressed: () {
                  if(contact.phone.toString().length > 9) {
                    _callNumber(contact.phone.toString());
                  }else{
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please check the Number"),backgroundColor: Colors.red,));
                  }
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
  }

  void _showLargerImage(UserList contact) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          height: 300,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.grey.shade400,
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: contact.image != null
                  ? MemoryImage(base64Decode(contact.image))
                  : AssetImage('assets/images/man.png')
              as ImageProvider<Object>,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  void _showContactInfoDialog(UserList contact) {
    showDialog(
      context: context,
      builder: (context) => InfoDialog(
        image: contact.image != null
            ? MemoryImage(base64Decode(contact.image))
            : AssetImage('assets/images/man.png') as ImageProvider<Object>,
        name: "${contact.firstName}",
        homeAddress: '${contact.address ?? ""}',
        officeAddress: '${contact.officeAddress ?? ""}',
        clerks: [
          ClerkInfo(
              name: contact.clerkName1 ?? "", phone: contact.clerkPhone1 ?? ""),
          ClerkInfo(
              name: contact.clerkName2 ?? "", phone: contact.clerkPhone2 ?? ""),
        ],
        bloodGroup: '${contact.bloodGroup ?? ""}', wpNumber: contact.whatsAppno??"", carNumber1: contact.carNumber1??"", carNumber2: contact.carNumber2??"", officeNumber: contact.officeNo??"",
      ),
    );
  }
  void _callNumber(String number) async {
    await FlutterPhoneDirectCaller.callNumber(number);
  }
}

class InfoDialog extends StatelessWidget {
  final String name;
  final String homeAddress;
  final String officeAddress;
  final String wpNumber;
  final List<ClerkInfo> clerks;
  final String bloodGroup;
  final String carNumber1;
  final String carNumber2;
  final String officeNumber;
  final ImageProvider<Object> image;

  InfoDialog({
    required this.image,
    required this.name,
    required this.homeAddress,
    required this.officeAddress,
    required this.clerks,
    required this.bloodGroup,
    required this.wpNumber,
    required this.carNumber1,
    required this.carNumber2,
    required this.officeNumber,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 70.w,
                height: 80.h,
                decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: image,
                    )),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text(
                    '$name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(onTap: (){
                  _openWhatsAppChat(wpNumber);
                }, child: Image(
                  width: 30,
                  image: AssetImage("assets/images/whatsapp.png"),)),
              )
            ],
          ),
          Divider(
            thickness: 2,
          )
        ],
      ),
      content: Container(
        height: 300.sp,
        decoration: BoxDecoration(
          color: Colors.grey.shade50,
          borderRadius: BorderRadius.circular(8),),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Home \nAddress: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '$homeAddress',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
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
                      'Office \nAddress: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '$officeAddress',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Clerks:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
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
                      SizedBox(height: 10),
                      Row(
                        children: [
                          SelectableText.rich(
                            TextSpan(
                              text: 'Phone: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              children: [
                                TextSpan(
                                  text: '${clerk.phone ?? "N/A"}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: IconButton(
                                onPressed: () {
                                  _callNumber(clerk.phone.toString());
                                },
                                icon: Icon(Icons.call)),
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                )),
                Row(
                  children: [
                    Text(
                      'Office Number : ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      officeNumber,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'Blood Group: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      bloodGroup,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'CarNumber 1: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      carNumber1,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      'CarNumber 2: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      carNumber2,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
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
  _openWhatsAppChat(String phoneNumber) async {
    final Uri url =
    Uri.parse('http://wa.me/$phoneNumber');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch url');
    }
  }
  void _callNumber(String number) async {
    if(number.length > 9){
      await FlutterPhoneDirectCaller.callNumber(number);
    }
  }
}

class ClerkInfo {
  final String? name;
  final String? phone;

  ClerkInfo({this.name, this.phone});
}
