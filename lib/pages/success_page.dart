import 'package:flutter/material.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Successful'),
      ),
      body: const Center(
        child: Text(
          'Payment was successful!',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}