import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorPage extends StatefulWidget {

  final int status;
  final String message;
  const ErrorPage({super.key, required this.status, required this.message});

  @override
  State<ErrorPage> createState() => _ErrorPage();
}

class _ErrorPage extends State<ErrorPage> {
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
              Lottie.asset('assets/animations/animation_unsuccessful.json',
                width: 150,
                height: 160,
              ),
              const SizedBox(height: 20),
              Text(widget.status ==2?'Entry Failed':'Exit Failed',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                ),
              ),
              SizedBox(height: 20,),
              Center(
                child: Text('Reason: ${widget.message}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.green[800],
                  ),
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
