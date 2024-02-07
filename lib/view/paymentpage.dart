import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controller/controllers.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {




  @override
  Widget build(BuildContext context,) {
    var pro = context.read<ControllerData>();
    final String amountPaid= pro.amount;

    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   title: Text('Payment Confirmation'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SizedBox(
            width: width,
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if(amountPaid=="0")
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 80.0,
                    ),
                    if(amountPaid!= "0")
                      Icon(
                        Icons.info_outline,
                        color: Colors.amber,
                        size: 80.0,
                      ),
                    SizedBox(height: 16.0),
                    if(amountPaid=="0")
                    Text(
                      'Paid!',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if(amountPaid!="0")
                      Text(
                        'Due!',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    SizedBox(height: 16.0),
                    if(amountPaid!="0")
                    Text(
                      'Amount to Pay',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey,
                      ),
                    ),
                    if(amountPaid!="0")
                    Text(
                      '₹$amountPaid',
                      style: TextStyle(
                        fontSize: 28.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24.0),
                    // ElevatedButton(
                    //   onPressed: () {
                    //     // Add any navigation or action you want to perform after payment confirmation
                    //   },
                    //   child: Text('Continue'),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}




