import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SuccessfulPage extends StatefulWidget {

  final int status;

  const SuccessfulPage({super.key, required this.status});

  @override
  State<SuccessfulPage> createState() => _SuccessfulPage();
}

class _SuccessfulPage extends State<SuccessfulPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/animations/animation_successful.json',
                width: 150,
                height: 160,
              ),
              const SizedBox(height: 20),
              Text(widget.status ==2?'Entry Successful':'Exit Successful',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  // Add your action for the first button here
                  // Navigate to the second page using Navigator.push
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
