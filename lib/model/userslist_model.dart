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
  String? nickName;
  String? phone;
  String? officeNo;
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
  String? carNumber1;
  String? carNumber2;
  String? annualFee;
  String? enrollmentDate;
  String? isRegisteredUser;
  String? isValidUser;
  String? paidAmount;
  dynamic image;

  UserList({
    this.id,
    this.regNo,
    this.firstName,
    this.nickName,
    this.phone,
    this.officeNo,
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
    this.carNumber1,
    this.carNumber2,
    this.annualFee,
    this.enrollmentDate,
    this.isRegisteredUser,
    this.isValidUser,
    this.paidAmount,
    this.image,
  });

  factory UserList.fromJson(Map<String, dynamic> json) => UserList(
    id: json["_id"],
    regNo: json["regNo"],
    firstName: json["firstName"],
    nickName: json["nickName"],
    phone: json["phone"],
    officeNo: json["officeNo"],
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
    carNumber1: json["carNumber1"],
    carNumber2: json["carNumber2"],
    annualFee: json["annualFee"],
    enrollmentDate: json["enrollmentDate"],
    isRegisteredUser: json["isRegisteredUser"],
    isValidUser: json["isValidUser"],
    paidAmount: json["paidAmount"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "regNo": regNo,
    "firstName": firstName,
    "nickName": nickName,
    "phone": phone,
    "officeNo": officeNo,
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
    "carNumber1": carNumber1,
    "carNumber2": carNumber2,
    "annualFee": annualFee,
    "enrollmentDate": enrollmentDate,
    "isRegisteredUser": isRegisteredUser,
    "isValidUser": isValidUser,
    "paidAmount": paidAmount,
    "image": image,
  };
}
