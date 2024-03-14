import 'package:flutter/material.dart';

class ScanDataPage extends StatelessWidget {
  final String data;

  const ScanDataPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scanned Data'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Text(data),
          ),
        ),
      ),
    );
  }
}