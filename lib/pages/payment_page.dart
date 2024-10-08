import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:qr_validator_app/pages/failed_page.dart';
import 'package:qr_validator_app/pages/success_page.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Future<WebViewController> _controllerFuture;
  bool _isLoading = true; // Track loading state

  // Your sessionId to pass
  String? sessionId;

  @override
  void initState() {
    super.initState();
    _controllerFuture = _initializePaymentSession();
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

  Future<WebViewController> _initializePaymentSession() async {
    try {
      sessionId = await fetchSessionId();
      print('Session ID: $sessionId');
      // Initialize WebViewController
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest: (NavigationRequest request) {
              print('Navigating to: ${request.url}'); // Add this line

              if (request.url.contains('myapp://payment-success')) {
                // Payment was successful, navigate to the success page in the app
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const SuccessPage()),
                );
                return NavigationDecision.prevent;
              } else if (request.url == 'myapp://payment-failed') {
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
            'http://10.0.2.2:3000/payment?sessionId=$sessionId')); // Replace with your actual URL

      return controller;
    } catch (error) {
      print('Error initializing payment session: $error');
      rethrow; // Propagate error to be handled by FutureBuilder
    }
  }

  Future<String> fetchSessionId() async {
    final dio = Dio();
    const url = 'http://10.0.2.2:5000/mpgs-payment/api/payment/initiateHostedCheckoutForPurchase';

    try {
      print('Fetching session ID...');
      final response = await dio.get(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch session ID');
      }

      final sessionId = response.data; // Assuming the response is plain text (sessionId)
      print('Fetched session ID: $sessionId');
      return sessionId;
    } catch (error) {
      print('Error fetching session ID: $error');
      throw error;
    }
  }
}