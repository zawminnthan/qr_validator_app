import 'package:flutter/material.dart';
import 'package:qr_validator_app/pages/entry_page.dart';
import 'package:qr_validator_app/pages/exit_page.dart';
import 'package:qr_validator_app/pages/hostedsession_payment_page.dart';
import 'package:qr_validator_app/pages/payment_page.dart';
import 'package:qr_validator_app/pages/scan_data_page.dart';
import 'package:qr_validator_app/pages/setting_page.dart';
import 'package:qr_validator_app/pages/success_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/json_property_name.dart';
import '../models/usage_txn_model.dart';
import '../service/base_api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {


  @override
  void initState() {
    super.initState();
    initProperties();
  }

  Future<void> initProperties() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("url", BaseAPIService.url);
    prefs.setString(kBrokerHostName, BaseAPIService.brokerHostName);
    prefs.setString(kClientId, BaseAPIService.clientId);
    prefs.setString(kPort, BaseAPIService.port);
    prefs.setString(kUserName, BaseAPIService.userName);
    prefs.setString(kPassword, BaseAPIService.password);
    prefs.setString(kTopicName, BaseAPIService.topicName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('QR Validator'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EntryPage()),
                    );
                  },
                  child: const Text('Entry Mode'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ExitPage()),
                    );
                  },
                  child: const Text('Exit Mode'),
                ),
              ],
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      //MaterialPageRoute(builder: (context) => PaymentScreen()),
                      MaterialPageRoute(builder: (context) => const PaymentPage()),
                    );
                  },
                  child: const Text('Make Payment with HostedCheckout'),
                ),
              ],
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const HostedSessionPaymentPage()),
                    );
                  },
                  child: const Text('Make Payment with HostedSession'),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add your action for the floating action button here
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingPage()),
          );
        },
        child: const Icon(Icons.settings),
      ),
    );
  }
}