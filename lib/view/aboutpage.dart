import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:taba_app_android/constants/constants.dart';

import 'bottom_nav_bar.dart';

class Member {
  final String? name;
  final String? position;
  final String? image;
  final String? phone;

  Member({
    this.name,
    this.position,
    this.image,
    this.phone,
  });
}

class Committee extends StatefulWidget {
  const Committee({super.key});

  @override
  State<Committee> createState() => _CommitteeState();
}

class _CommitteeState extends State<Committee> {
  List<Member> executiveMembers = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  var data;

  Future<void> fetchData() async {
    final url = Uri.parse('$adminBaseUrl/about');
    final response = await http.get(url, headers: {
      "Content-Type": "application/json",
    });
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
      setState(() {});
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Member president = Member(
      name: data != null ? data![0]["name"] : null,
      position: data != null ? data![0]["description"] : null,
      image: data != null ? data![0]["image"] : null,
      phone: data != null ? data![0]["phone"] : null,
    );

    final Member secretary = Member(
      name:  data != null ? data![1]["name"] : null,
      position:  data != null ? data![1]["description"] : null,
      image: data != null ? data![1]["image"] : null,
      phone: data != null ? data![1]["phone"] : null,
    );

    final Member librarian = Member(
      name: data != null ? data![2]["name"] : null,
      position: data != null ? data![2]["description"] : null,
      image: data != null ? data![2]["image"] : null,
      phone: data != null ? data![2]["phone"] : null,
    );

    final List<Member> executiveMembers = [
      Member(name: data != null ? data![3]["name"]: null, position: data != null ? data![3]["description"] : null, image: data != null ? data![3]["image"] : null,phone: data != null ? data![3]["phone"] : null),
      Member(name:data != null ? data![4]["name"]: null, position: data != null ? data![4]["description"] : null, image: data != null ? data![4]["image"] : null,phone: data != null ? data![4]["phone"] : null),
      Member(name: data != null ? data![5]["name"]: null, position: data != null ? data![5]["description"] : null, image: data != null ? data![5]["image"] : null,phone: data != null ? data![5]["phone"] : null),
      Member(name: data != null ? data![6]["name"]: null, position: data != null ? data![6]["description"] : null, image: data != null ? data![6]["image"] : null,phone: data != null ? data![6]["phone"] : null),
      Member(name: data != null ? data![7]["name"]: null, position: data != null ? data![7]["description"] : null, image: data != null ? data![7]["image"] : null,phone: data != null ? data![7]["phone"] : null),
      Member(name: data != null ? data![8]["name"]: null, position: data != null ? data![8]["description"] : null, image: data != null ? data![8]["image"] : null,phone: data != null ? data![8]["phone"] : null),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Executive Committee',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => BottomNavigationPage(),));
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    _buildMemberWidget(president),
                    _buildMemberWidget(secretary),
                    _buildMemberWidget(librarian),
                  ],
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Executive Members',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white,),
                  ),
                ),
               const SizedBox(height: 30),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (var member in executiveMembers)
                        Row(
                          children: [
                            _buildMemberWidget(member),
                            SizedBox(width: 30),
                          ],
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMemberWidget(Member member) {
    return Column(
      children: [
        CircleAvatar(
          radius: 43,
          backgroundColor: Colors.grey.shade300,
          child: CircleAvatar(
            radius: 40,
            backgroundImage: member.image != null
                ? MemoryImage(base64Decode(member.image!))
                : AssetImage('assets/images/man.png') as ImageProvider<Object>?,
          ),
        ),
        SizedBox(height: 10),
        Text(
          member.name ?? '',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
        ),
       const SizedBox(height: 5),
        SizedBox(
          width: 200.sp,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  member.position ?? '',
                  style: TextStyle(fontSize: 12,color: Colors.white),textAlign: TextAlign.center,
                ),
              ),
              IconButton(onPressed: (){
                _callNumber(member.phone.toString());
              }, icon: Icon(Icons.call,color: Colors.white,))
            ],
          ),
        ),
        Divider()
      ],
    );
  }
  void _callNumber(String number) async {
    if(number.length > 9){
      await FlutterPhoneDirectCaller.callNumber(number);
    }
  }
}
