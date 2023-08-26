import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Map<String,dynamic>? _paymentIntent;
  createPaymentIntent()async{
    try{
    Map<String,dynamic> body={
      'amount':'100',
      'currency':'USD'
    };
    Response response=await post(Uri.parse('https://api.stripe.com/v1/payment_intents'),
    body: body,
    headers: {
      'Authorization':'Bearer sk_test_51NgU7DEzPqpqMUXxcq1qeMFJ6ieM86tawlVdD27YPc4ue0HYZ51Q5hDbb9FEEQYhRy4RR1FTzDAF4HiKQyzs66A9002aqKIvTM'
      ,'Content-Type':'application/x-www-form-urlencoded',
    });
    return jsonDecode(response.body);
    }
    catch(e){
     throw Exception(e.toString());
    }
  }
 void _displayPaymentSheet()async{
  try {
  await Stripe.instance.presentPaymentSheet();
    print('Done');
  } catch (e) {
    print('failed');
    
  }
 }
 void makePayment()async{
  try {
    _paymentIntent=await createPaymentIntent();
    var gpa=PaymentSheetGooglePay(
    merchantCountryCode: 'USD',
    currencyCode: 'USD',
    testEnv: true);
    
   await Stripe.instance.initPaymentSheet(paymentSheetParameters: SetupPaymentSheetParameters(
  paymentIntentClientSecret: _paymentIntent!['client_secret'],
  style: ThemeMode.light,
  merchantDisplayName: 'Muhammad Umar',
  googlePay: gpa,
  ));
    _displayPaymentSheet();
  } catch (e) {
    throw Exception(e.toString());
  }
 }
  @override
  void initState() {
    super.initState();
    Stripe.publishableKey='pk_test_51NgU7DEzPqpqMUXxybaHa4izytlbmqIaHJQSWAqRGHNVnfovTGcIUFm4OYL59NIfkyUbTqQ2Us72JjINmvSFZkCm00e6XrPZt2';
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
              
              Center(
                child: ElevatedButton(onPressed: (){
                   makePayment();
                }, child: Text('Open Payment Sheet')),
              )
               ],
      ),
    );
  }
  
  
 
}