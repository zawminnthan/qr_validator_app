import 'package:flutter/material.dart';

class FailedPage extends StatelessWidget {
  const FailedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Failed'),
      ),
      body: const Center(
        child: Text(
          'Payment was failed!',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}