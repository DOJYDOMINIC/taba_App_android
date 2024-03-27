
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';


const url = "https://aba.zenonsystems.com/api";


const baseUrl = "$url/user";
const adminBaseUrl = "$url/admin";
const notificationUrl = "$url/notification";

final box = Hive.box('data_box');

const Color appColor = Color.fromRGBO(125, 125, 125, 100);

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
    borderRadius: BorderRadius.circular(10),
    borderSide: BorderSide(
      width: 2,
      color: appColor.withOpacity(.3),
    ),
  ),
  hintText: 'Search',
  fillColor: Colors.white,
  filled: true,
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.sp),
    borderSide: BorderSide(
      width: 2.w,
      color: appColor,
    ),
  ),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20.sp),
    borderSide: const BorderSide(color: Colors.white),
  ),
);

const rollNumber = "Roll Number";
String defaultImage = "/9j/4AAQSkZJRgABAQACWAJYAAD/2wBDAAgGBgcGBQgHBwcJCQgKDBQNDAsLDBkSEw8UHRofHh0aHBwgJC4nICIsIxwcKDcpLDAxNDQ0Hyc5PTgyPC4zNDL/wgALCADIAMgBAREA/8QAHAABAAIDAQEBAAAAAAAAAAAAAAYIAwUHAgEE/9oACAEBAAAAAO/gAAAAAAAAAAAAAAAAAAAAAAAAAD8PDIfMO5/uAAA81AgJPrf+gAAQumgXLmgAAIJTsLiTsAAGGmEVJVc/MAABoq8Q+YWH3oAAB8wZ/oAACH8I53rtj0Tu8wAADjdasIZrK9kAAOfVE8Ae7d9BAAU4g4BOLjgAaWjnkA+3k3QAIvXIALGygAAAAAAAAAAAAAAAAAAAAAAAAAH/xAA5EAABAgQCBgYIBgMAAAAAAAABAgMEBQYRAAcSFyExUWETQFSBlKEUFSAwQVJxsQgWImJwwXOR0f/aAAgBAQABPwD+IJvOICRS52YTKKbhoVoXU4s27hxPLFTfiLWHls03LEFsGwiYu91cwgbu84191z0un6VB6PyejJt/3FM/iLWXkM1JLEBsmxiYS908yg7+44lE4gJ7LmphLYpuJhXRdLiDfuPA8uqOOJabU4tQShIKlKO4AYzSzAia0qJ1DTqhKYVZRDNA7FW2aZ5n7exlbmBE0XUTSHXVGUxSwiJaJ2Jvs0xzH2w24h1tLiFBSFAKSobiD1PNmaOSjLOcxDSilxbQZSR8NMhP2J9rKaaOTfLOTRDqipxDRZUT8dAlI8gOp5xQC5hldOENglTSEvWHBKgT5X9rJ2AXL8rpOhwFKnUKeseClEjyt1OKhmoyFdhn0BbLqChaT8UkWIxmBRsXRVTPwDyFGFUSuFetscbO7vG4+xl/RsXWtTMQDKFCFSQuKetsbbG/vO4YhYZqDhWoZhIQ00gIQkbgkCwHVKqpKUVhKVS+bQ4Wje24nYtpXFJ+GKmyBqWWPLckym5pC70gKCHQOaTsPccas616Xo/y1MNL/Fs/3uxTOQNSzN5Dk5U3K4XeoFQW6RySNg7zilaSlFHylMvlMOEI3uOK2rdVxUfj1ZSkoF1EAcSbY9OhL29KYvw6QYSpKxdJBHEG/VayzJp+imimPieljSLohGLKcP1+UfXFSZ+VRNVrblQalUMdg6Mabluaj/QxH1HOpo4Vx02jYhR39I+o+V8dM5e/SLvx0jiAqOdytwOQM2jYdQ3dG+oeV8U3n5VEqWhuahqaww2HpBoOW5KH9jFG5k0/WrQTARPRRoF1wj9kuD6fMPp1LNnN8U6XJHIHErmhFnnxtEPyHFX2xFRT8bEuRMS8t59xWktxxV1KPEn2oWKfgoluJhnlsvtq0kONqspJ4g4ymzfFRFuRz9xKJoBZl87BEcjwV9+oZs14KLpgiFWPWkZduGHycV933w885EPLeeWpbi1FSlKNyoneT7hl5yHeQ8ytSHEKCkqSbFJG4jGU1eCtaYAilj1pB2biR8/Bff8Af327GbFUKqivY55KyqEhVGGhxfZopNie83Pusp6oVS9ewLy3CmEilCGiBfZoqNge42ON/vavmfqaj5vMQbKh4RxaT+7R2edsKUVqKlG5JuT7pKihQUk2INweBxSEz9c0fKJiTdT8I2tR/do7fO/vcxJRHz+hJpKpYhK4uJbCEJUoJB/UCdp5Y1EV52CG8UjGoivOwQ3ikY1EV52CG8UjGoivOwQ3ikY1EV52CG8UjGoivOwQ3ikY1EV52CG8UjGoivOwQ3ikY1EV52CG8UjGoivOwQ3ikY1EV52CG8UjGXcoj5BQkrlUzQlEXDNlC0pUFAfqJG0crfw7/9k=";