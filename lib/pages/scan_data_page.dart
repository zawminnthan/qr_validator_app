import 'package:flutter/material.dart';

class ScanDataPage extends StatelessWidget {
  final String data;

  const ScanDataPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text('Scanned Data'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Text(data),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality for the floating action button here
        },
        backgroundColor: Colors.blue,
        child: const SizedBox(
          width: 50, // Set your desired width here
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}