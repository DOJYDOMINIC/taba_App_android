// To parse this JSON data, do
//
//     final userList = userListFromJson(jsonString);

import 'dart:convert';

UserList userListFromJson(String str) => UserList.fromJson(json.decode(str));

String userListToJson(UserList data) => json.encode(data.toJson());

class UserList {
  String? id;
  String? regNo;
  String? firstName;
  String? lastName;
  String? phone;
  String? password;
  String? email;
  String? dob;
  String? whatsAppno;
  String? address;
  String? officeAddress;
  String? clerkName1;
  String? clerkName2;
  String? clerkPhone1;
  String? clerkPhone2;
  String? bloodGroup;
  String? welfareMember;
  String? pincode;
  String? district;
  String? state;
  String? annualFee;
  String? enrollmentDate;
  dynamic image;
  bool? isRegisteredUser;
  bool? isValidUser;

  UserList({
    this.id,
    this.regNo,
    this.firstName,
    this.lastName,
    this.phone,
    this.password,
    this.email,
    this.dob,
    this.whatsAppno,
    this.address,
    this.officeAddress,
    this.clerkName1,
    this.clerkName2,
    this.clerkPhone1,
    this.clerkPhone2,
    this.bloodGroup,
    this.welfareMember,
    this.pincode,
    this.district,
    this.state,
    this.annualFee,
    this.enrollmentDate,
    this.image,
    this.isRegisteredUser,
    this.isValidUser,
  });

  factory UserList.fromJson(Map<String, dynamic> json) => UserList(
    id: json["_id"],
    regNo: json["regNo"],
    firstName: json["firstName"],
    lastName: json["lastName"],
    phone: json["phone"],
    password: json["password"],
    email: json["email"],
    dob: json["DOB"],
    whatsAppno: json["whatsAppno"],
    address: json["address"],
    officeAddress: json["officeAddress"],
    clerkName1: json["clerkName1"],
    clerkName2: json["clerkName2"],
    clerkPhone1: json["clerkPhone1"],
    clerkPhone2: json["clerkPhone2"],
    bloodGroup: json["bloodGroup"],
    welfareMember: json["welfareMember"],
    pincode: json["pincode"],
    district: json["district"],
    state: json["state"],
    annualFee: json["annualFee"],
    enrollmentDate: json["enrollmentDate"],
    image: json["image"],
    isRegisteredUser: json["isRegisteredUser"],
    isValidUser: json["isValidUser"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "regNo": regNo,
    "firstName": firstName,
    "lastName": lastName,
    "phone": phone,
    "password": password,
    "email": email,
    "DOB": dob,
    "whatsAppno": whatsAppno,
    "address": address,
    "officeAddress": officeAddress,
    "clerkName1": clerkName1,
    "clerkName2": clerkName2,
    "clerkPhone1": clerkPhone1,
    "clerkPhone2": clerkPhone2,
    "bloodGroup": bloodGroup,
    "welfareMember": welfareMember,
    "pincode": pincode,
    "district": district,
    "state": state,
    "annualFee": annualFee,
    "enrollmentDate": enrollmentDate,
    "image": image,
    "isRegisteredUser": isRegisteredUser,
    "isValidUser": isValidUser,
  };
}
