
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';

const baseUrl = "http://94.176.237.33:3000/api/user";
const Color appcolor = Color.fromRGBO(125, 125, 125, 100);
  final box = Hive.box('data_box');


//Decoration
InputDecoration myInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(
    vertical: 10.sp,
    horizontal: 10.sp,
  ),
  suffixIcon: Padding(
    padding: EdgeInsets.fromLTRB(0.sp, 0.sp, 15.sp, 0.sp),
  ),
  errorBorder: const UnderlineInputBorder(
    borderSide: BorderSide(color: Colors.transparent),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.sp),
    borderSide: BorderSide(
      width: 2.w,
      color: appcolor.withOpacity(.3),
    ),
  ),
  hintText: 'Search',
  fillColor: Colors.white,
  filled: true,
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.sp),
    borderSide: BorderSide(
      width: 2.w,
      color: appcolor,
    ),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.sp),
    borderSide: const BorderSide(color: Colors.white),
  ),
);