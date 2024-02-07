
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:readmore/readmore.dart';

import 'bottom_nav_bar.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationPage(),));
        }, icon:Icon(Icons.arrow_back_ios_new_outlined,color: Colors.white)),
        centerTitle: true,
        title: Text(
          "Notification",
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 5,left: 10,right: 10),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            color: Colors.grey.shade900,
            child: ListTile(
              title: SelectableText("Title",
                toolbarOptions: ToolbarOptions(copy: true),
                showCursor: true,
                style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                height: 1.6.h,
              ),),
              subtitle: ReadMoreText(
                  'sdvfbgnhmcnf xbdzvsFGhgnmhx bcvzbfd vsgfegarehtsgnfxz bfvdgearehsdgnxzvb vDFeGARHSDZGNXCV XCVDGARH FBZVDFeagrfdzbv DFagsfdxbv cvzdFsgfzbd ',
                  style: TextStyle(
                    color: Color(0xFF9B9B9B),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    height: 1.6.h,
                  ),
                  trimLines: 2,
                  colorClickableText: Color(0xFFC67C4E),
                  trimMode: TrimMode.Line,
                  trimLength: 10,
                  trimCollapsedText: 'Read More',
                  trimExpandedText: 'Show less',
                  moreStyle: TextStyle(
                    color: Color(0xFFC67C4E),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    height: 0.12.h,
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
