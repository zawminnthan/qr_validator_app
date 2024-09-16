import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qr_validator_app/pages/success_page.dart';

import '../models/prepared_pay_with_hosted_session.dart';

class PaymentProcessingPage extends StatefulWidget {
  final PreparedPayWithHostedSession preparedPayWithHostedSession;
  const PaymentProcessingPage({super.key, required this.preparedPayWithHostedSession});

  @override
  State<PaymentProcessingPage> createState() => _PaymentProcessingPageState();
}

class _PaymentProcessingPageState extends State<PaymentProcessingPage> {
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    capturePaymentWithHostedSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Processing'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator() // Show progress circle when loading
            : const Text(
          'Authentication was successful and payment is processing!',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }

  Future<void> capturePaymentWithHostedSession() async {
    final dio = Dio();
    const url = 'http://10.0.2.2:5000/mpgs-payment/api/payment/capturePaymentWithHostedSession';

    var body = jsonEncode(widget.preparedPayWithHostedSession);
    log('Body: $body');
    try {
      print('Fetching session ID...');
      final response = await dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data: body,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to capturePaymentWithHostedSession');
      }

      setState(() {
        _isLoading = false; // Stop loading once the API call is complete
      });

      // Payment was successful, navigate to the success page in the app
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SuccessPage()),
      );
    } catch (error) {
      print('Error capturePaymentWithHostedSession: $error');
      throw error;
    }
  }
}