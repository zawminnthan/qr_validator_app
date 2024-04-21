import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:qr_validator_app/models/usage_txn_model.dart';
import 'package:qr_validator_app/pages/error_page.dart';
import 'package:qr_validator_app/pages/successful_page.dart';
import 'package:qr_validator_app/service/usage_txn_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/json_property_name.dart';
import '../models/response_model.dart';
import '../service/base_api_service.dart';


class ScanDataPage extends StatefulWidget {
  final UsageTxnModel usageTxnModel;
  const ScanDataPage({Key? key,required this.usageTxnModel}) : super(key: key);

  @override
  State<ScanDataPage> createState() => _ScanDataPage();
}

class _ScanDataPage extends State<ScanDataPage> {
  final UsageTxnService usageTxnService = UsageTxnService();
  bool _isLoading = false; // Flag to track loading state
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme
            .of(context)
            .colorScheme
            .secondary,
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
                child: Text(widget.usageTxnModel.qrData),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
        onPressed: () async {
          setState(() {
            _isLoading = true;
          });
          //bool result = await usageTxnService.validateTxn(widget.usageTxnModel);
          bool result = await validateTxn(widget.usageTxnModel);
          if (result) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SuccessfulPage(status: widget.usageTxnModel.status),
              ),
            );
          }else{
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ErrorPage(status: widget.usageTxnModel.status, message: errorMessage,),
              ),
            );
          }
          setState(() {
            _isLoading = false;
          });
        },
        label: _isLoading ? const CircularProgressIndicator() : const Text(
            'Submit'),
        icon: const Icon(Icons.add, color: Colors.white, size: 25),
      ),
    );
  }

  Future<bool> validateTxn(UsageTxnModel req) async {
    try {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? storedUrl = prefs.getString("url");
      String url;
      if (storedUrl != null && storedUrl.isNotEmpty) {
        url = storedUrl;
      } else {
        url = BaseAPIService.url;
      }

      BaseAPIService.baseUrl = url;
      ResponseModel responseModel = await BaseAPIService.post(req.toJson(), kValidate);

      if (responseModel.responseCode == "200") {
        return true;
      } else {
        errorMessage = responseModel.responseMsg;
        log('Transaction failed');
        throw Exception('Transaction failed');
      }
    } catch (e) {
      // Log the exception
      log('Exception during transaction process: $e');
    }
    return false;
  }
}