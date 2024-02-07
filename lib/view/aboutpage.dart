import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Member {
  final String? name;
  final String? position;
  final String? image;

  Member({
    this.name,
    this.position,
    this.image,
  });
}

class AboutPage extends StatefulWidget {
  AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  List<Member> executiveMembers = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  var data;

  Future<void> fetchData() async {
    final url = Uri.parse('http://94.176.237.33:3000/api/admin/about');
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
    );

    final Member secretary = Member(
      name:  data != null ? data![1]["name"] : null,
      position:  data != null ? data![1]["description"] : null,
      image: data != null ? data![1]["image"] : null,
    );

    final Member librarian = Member(
      name: data != null ? data![2]["name"] : null,
      position: data != null ? data![2]["description"] : null,
      image: data != null ? data![2]["image"] : null,
    );

    final List<Member> executiveMembers = [
      Member(name: data != null ? data![3]["name"]: null, position: data != null ? data![3]["description"] : null, image: data != null ? data![3]["image"] : null,),
      Member(name:data != null ? data![4]["name"]: null, position: data != null ? data![4]["description"] : null, image: data != null ? data![4]["image"] : null,),
      Member(name: data != null ? data![5]["name"]: null, position: data != null ? data![5]["description"] : null, image: data != null ? data![5]["image"] : null,),
      Member(name: data != null ? data![6]["name"]: null, position: data != null ? data![6]["description"] : null, image: data != null ? data![6]["image"] : null,),
      Member(name: data != null ? data![7]["name"]: null, position: data != null ? data![7]["description"] : null, image: data != null ? data![7]["image"] : null,),
      Member(name: data != null ? data![8]["name"]: null, position: data != null ? data![8]["description"] : null, image: data != null ? data![8]["image"] : null,),
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Executive Committee'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMemberWidget(president),
                  // SizedBox(height: 20),
                  _buildMemberWidget(secretary),
                ],
              ),
              _buildMemberWidget(librarian),
              SizedBox(height: 20),
              Text(
                'Executive Members:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 30),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMemberWidget(Member member) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: member.image != null
              ? MemoryImage(base64Decode(member.image!))
              : AssetImage('assets/images/man.png') as ImageProvider<Object>?,
        ),
        SizedBox(height: 10),
        Text(
          member.name ?? '',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        SizedBox(
          width: 100,
          child: Text(
            member.position ?? '',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
