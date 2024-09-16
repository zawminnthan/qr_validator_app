import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qr_validator_app/models/order_request.dart';
import 'package:qr_validator_app/models/prepared_pay_with_hosted_session.dart';
import 'package:qr_validator_app/pages/failed_page.dart';
import 'package:qr_validator_app/pages/success_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'payment_processing_page.dart';

class HostedSessionPaymentPage extends StatefulWidget {
  const HostedSessionPaymentPage({super.key});

  @override
  _HostedSessionPaymentPageState createState() => _HostedSessionPaymentPageState();
}

class _HostedSessionPaymentPageState extends State<HostedSessionPaymentPage> {
  late Future<WebViewController> _controllerFuture;
  bool _isLoading = true; // Track loading state

  // Your sessionId to pass
  String? sessionId;

  @override
  void initState() {
    super.initState();
    _controllerFuture = _preparedPayWithHostedSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: FutureBuilder<WebViewController>(
        future: _controllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final WebViewController? controller = snapshot.data;

          return Stack(
            children: [
              WebViewWidget(controller: controller!),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          );
        },
      ),
    );
  }

  Future<WebViewController> _preparedPayWithHostedSession() async {
    try {
      PreparedPayWithHostedSession data = await fetchSessionId();
      print('Session ID: ${data.sessionId}');
      // Initialize WebViewController
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest: (NavigationRequest request) {
              print('Navigating to: ${request.url}'); // Add this line

              if (request.url.contains('myapp://auth-success')) {
                // Payment was successful, navigate to the success page in the app
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) =>
                  PaymentProcessingPage(preparedPayWithHostedSession: data,)),
                );
                return NavigationDecision.prevent;
              } else if (request.url.contains('myapp://auth-failed')) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const FailedPage()),
                );
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            onPageStarted: (String url) {
              setState(() {
                _isLoading = true; // Show loading indicator
              });
            },
            onPageFinished: (String url) {
              setState(() {
                _isLoading = false; // Hide loading indicator
              });
            },
          ),
        )
        ..loadRequest(Uri.parse(
            'http://10.0.2.2:3000/hosted_session_payament?sessionId=${data.sessionId}&merchantId=${data.merchantId}&orderId=${data.orderId}&transactionId=${data.transactionId}')); // Replace with your actual URL

      return controller;
    } catch (error) {
      print('Error initializing payment session: $error');
      rethrow; // Propagate error to be handled by FutureBuilder
    }
  }

  Future<PreparedPayWithHostedSession> fetchSessionId() async {
    final dio = Dio();
    const url = 'http://10.0.2.2:5000/mpgs-payment/api/payment/preparedPayWithHostedSession';

    OrderRequest request = OrderRequest(redirectResponseUrl: "myapp://payment-success",
        amount: "100.00", currency: "MYR");

    var body = jsonEncode(request);
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
        data: body
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch session ID');
      }
      return PreparedPayWithHostedSession.fromJson(response.data);
    } catch (error) {
      print('Error fetching session ID: $error');
      throw error;
    }
  }
}