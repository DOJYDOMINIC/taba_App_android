import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../controller/controllers.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  @override
  void initState() {
    super.initState();
    context.read<UserDataProvider>().fetchUserData();
  }
  @override
  Widget build(BuildContext context,) {
    var pro = context.read<ControllerData>();
    var user = context.read<UserDataProvider>();
     String amountPaid= pro.amount;
    double amt = double.parse(amountPaid);

    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: Text('Payment Confirmation'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child:user.data == null? CircularProgressIndicator(): SizedBox(
            width: width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(amt < 0)
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child: SizedBox(
                    width: width,
                    child: DealCard(
                      title: user.data!.regNo.toString(),
                      description: 'Advance Balance',
                      rupees: '$amt',
                    ),
                  ),
                ),
                if(amt == 0)
                Padding(
                  padding: const EdgeInsets.only(left: 20,right: 20),
                  child: SizedBox(
                    width: width,
                    child: DealCard(
                      title: user.data!.regNo.toString(),
                      description: 'Paid',
                      rupees: '$amt',
                    ),
                  ),
                ),
                if(amt > 0)
                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20),
                    child: SizedBox(
                      width: width,
                      child: DealCard(
                        title: user.data!.regNo.toString(),
                        description: 'Amount Due',
                        rupees: '$amt',
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}



class DealCard extends StatelessWidget {
  final String title;
  final String description;
  final String rupees;

  const DealCard({
    required this.title,
    required this.description,
    required this.rupees,
  });

  @override
  Widget build(BuildContext context) {
   var pro = context.read<ControllerData>();
   var user = context.read<UserDataProvider>();
   String amountPaid= pro.amount;
   double amt = double.parse(amountPaid);
    return Card(
      color: Colors.grey.shade300,
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 96.sp, // Adjust the height as needed
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white,width: 2),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    color: Colors.white,
                    child: user.data?.image != null
                        ? Image.memory(
                      base64Decode(user.data!.image ?? ""),
                      width: 90.sp, // Adjust the width as needed
                      height: 90.sp, // Adjust the height as needed
                      fit: BoxFit.cover,
                    )
                        : Image.asset(
                      'assets/images/man.png',
                      width: 90.sp, // Adjust the width as needed
                      height: 90.sp, // Adjust the height as needed
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,),
                SizedBox(height: 8),
                Text(
                  'Rs : $rupees',
                  style: TextStyle(fontSize: 16,color:amt > 0?Colors.red.shade500 : Colors.green ,fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
