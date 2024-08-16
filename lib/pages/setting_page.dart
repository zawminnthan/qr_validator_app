import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_validator_app/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/json_property_name.dart';
import '../service/base_api_service.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPage();
}

class _SettingPage extends State<SettingPage> {
  TextEditingController _urlController = TextEditingController(); // Controller for the URL TextField
  TextEditingController _brokerHostNameController = TextEditingController();
  TextEditingController _clientIdController = TextEditingController();
  TextEditingController _portController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _topicNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await _setControllerValue(
      prefs: prefs,
      key: "url",
      controller: _urlController,
      defaultValue: BaseAPIService.url,
    );

    await _setControllerValue(
      prefs: prefs,
      key: kBrokerHostName,
      controller: _brokerHostNameController,
      defaultValue: BaseAPIService.brokerHostName,
    );

    await _setControllerValue(
      prefs: prefs,
      key: kClientId,
      controller: _clientIdController,
      defaultValue: BaseAPIService.clientId,
    );

    await _setControllerValue(
      prefs: prefs,
      key: kPort,
      controller: _portController,
      defaultValue: BaseAPIService.port,
    );

    await _setControllerValue(
      prefs: prefs,
      key: kUserName,
      controller: _userNameController,
      defaultValue: BaseAPIService.userName,
    );

    await _setControllerValue(
      prefs: prefs,
      key: kPassword,
      controller: _passwordController,
      defaultValue: BaseAPIService.password,
    );

    await _setControllerValue(
      prefs: prefs,
      key: kTopicName,
      controller: _topicNameController,
      defaultValue: BaseAPIService.topicName,
    );
  }

  Future<void> _setControllerValue({
    required SharedPreferences prefs,
    required String key,
    required TextEditingController controller,
    required String defaultValue,
  }) async {
    String? value = prefs.getString(key);
    setState(() {
      controller.text =
      value != null && value.isNotEmpty ? value : defaultValue;
    });
  }

  @override
  void dispose() {
    _urlController.dispose(); // Dispose of the controller when the widget is disposed
    _brokerHostNameController.dispose();
    _clientIdController.dispose();
    _portController.dispose();
    _userNameController.dispose();
    _passwordController.dispose();
    _topicNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .inversePrimary,
        title: const Text('Settings'), // Set app bar title
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new), // Back button icon
          onPressed: () {
            Navigator.pop(context); // Navigate back when back button is pressed
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              TextField(
                controller: _urlController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Enter Backend Server URL', // Label for the TextField
                  border: OutlineInputBorder(), // Add border to the TextField
                  labelStyle: TextStyle(
                      fontSize: 13), // Set font size for the label
                ),
                style: const TextStyle(
                    fontSize: 13), // Set font size for the input text
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _brokerHostNameController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'MQTT Broker Host Name/IP', // Label for the TextField
                  border: OutlineInputBorder(), // Add border to the TextField
                  labelStyle: TextStyle(
                      fontSize: 13), // Set font size for the label
                ),
                style: const TextStyle(
                    fontSize: 13), // Set font size for the input text
              ),
              const SizedBox(height: 20), // Add spacing below the TextField
              TextField(
                controller: _clientIdController,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: 'MQTT Client ID', // Label for the TextField
                  border: OutlineInputBorder(), // Add border to the TextField
                  labelStyle: TextStyle(
                      fontSize: 13), // Set font size for the label
                ),
                style: const TextStyle(
                    fontSize: 13), // Set font size for the input text
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _portController,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: 'MQTT Port', // Label for the TextField
                  border: OutlineInputBorder(), // Add border to the TextField
                  labelStyle: TextStyle(
                      fontSize: 13), // Set font size for the label
                ),
                style: const TextStyle(
                    fontSize: 13), // Set font size for the input text
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _userNameController,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: 'MQTT User', // Label for the TextField
                  border: OutlineInputBorder(), // Add border to the TextField
                  labelStyle: TextStyle(
                      fontSize: 13), // Set font size for the label
                ),
                style: const TextStyle(
                    fontSize: 13), // Set font size for the input text
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _passwordController,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: 'MQTT Password', // Label for the TextField
                  border: OutlineInputBorder(), // Add border to the TextField
                  labelStyle: TextStyle(
                      fontSize: 13), // Set font size for the label
                ),
                style: const TextStyle(
                    fontSize: 13), // Set font size for the input text
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _topicNameController,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: 'MQTT Topic Name', // Label for the TextField
                  border: OutlineInputBorder(), // Add border to the TextField
                  labelStyle: TextStyle(
                      fontSize: 13), // Set font size for the label
                ),
                style: const TextStyle(
                    fontSize: 13), // Set font size for the input text
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Add your save action here
                  String url = _urlController.text;
                  String brokerHostName = _brokerHostNameController.text;
                  String clientId = _clientIdController.text;
                  String port = _portController.text;
                  String userName = _userNameController.text;
                  String password = _passwordController.text;
                  String topicName = _topicNameController.text;

                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setString("url", url);
                  prefs.setString(kBrokerHostName, brokerHostName);
                  prefs.setString(kClientId, clientId);
                  prefs.setString(kPort, port);
                  prefs.setString(kUserName, userName);
                  prefs.setString(kPassword, password);
                  prefs.setString(kTopicName, topicName);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}