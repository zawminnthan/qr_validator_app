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
  late final WebViewController _controller;
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();

    // Initialize WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            print('Navigating to: ${request.url}'); // Add this line

            if (request.url == 'myapp://payment-success') {
              // Payment was successful, navigate to the success page in the app
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SuccessPage()),
              );
              return NavigationDecision.prevent;
            }else if(request.url == 'myapp://payment-failed'){
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
      ..loadRequest(Uri.parse('http://10.0.2.2:3000/payment')); // Replace with your actual URL
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}