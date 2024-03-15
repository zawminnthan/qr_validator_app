import 'package:flutter/material.dart';
import 'package:qr_validator_app/pages/entry_page.dart';

import 'exit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('QR Validator'),
        centerTitle: true,
      ),
      body: Center( // Center the buttons horizontally
        child: Row( // Arrange buttons horizontally
          mainAxisAlignment: MainAxisAlignment.center, // Center buttons within the row
          children: [
            ElevatedButton(
              onPressed: () {
                // Add your action for the first button here
                // Navigate to the second page using Navigator.push
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EntryPage()),
                );
              },
              child: const Text('Entry'),
            ),
            const SizedBox(width: 20), // Add spacing between buttons
            ElevatedButton(
              onPressed: () {
                // Add your action for the second button here
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExitPage()),
                );
              },
              child: const Text('Exit'),
            ),
            const SizedBox(width: 20), // Add spacing between buttons
          ],
        ),
      ),
    );
  }
}