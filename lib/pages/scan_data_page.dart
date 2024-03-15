import 'package:flutter/material.dart';
import 'package:qr_validator_app/models/usage_txn_model.dart';
import 'package:qr_validator_app/pages/successful_page.dart';
import 'package:qr_validator_app/service/usage_txn_service.dart';


class ScanDataPage extends StatefulWidget {
  final UsageTxnModel usageTxnModel;
  const ScanDataPage({Key? key,required this.usageTxnModel}) : super(key: key);

  @override
  State<ScanDataPage> createState() => _ScanDataPage();
}

class _ScanDataPage extends State<ScanDataPage> {
  final UsageTxnService usageTxnService = UsageTxnService();
  bool _isLoading = false; // Flag to track loading state
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
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
            //await usageTxnService.validateTxn(widget.usageTxnModel);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SuccessfulPage(status: widget.usageTxnModel.status),
              ),
            );
            setState(() {
              _isLoading = false;
            });
          },
          label: _isLoading ? const CircularProgressIndicator() : const Text('Submit'),
          icon: const Icon(Icons.add, color: Colors.white, size: 25),
        ),
    );
  }
}