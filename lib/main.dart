import 'package:flutter/material.dart';
import 'package:qr_validator_app/pages/entry_page.dart';
import 'package:qr_validator_app/pages/scan_data_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Validator'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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