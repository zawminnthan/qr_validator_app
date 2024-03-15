import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_validator_app/models/usage_txn_model.dart';
import 'package:qr_validator_app/pages/scan_data_page.dart';

class ExitPage extends StatefulWidget {
  const ExitPage({Key? key}) : super(key: key);

  @override
  State<ExitPage> createState() => _ExitPageState();
}

class _ExitPageState extends State<ExitPage> {
  Barcode? result;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool navigating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('QR Code Scanner'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
         /* if (result != null)
            Text(
                'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
          else*/
            const Text('Scanning...'),
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      if (!navigating) {
        setState(() {
          result = scanData;
        });
        // Do something with the scan data, for example:
        print('Scanned data: ${scanData.code}');
        // Add your logic to handle the scanned data here

        // Always navigate to a new page
        _navigateToNextPage(scanData.code);
        navigating = true;
      }
    });
  }

  void _navigateToNextPage(String? data) {
    if (data != null) {
      controller?.pauseCamera();
      UsageTxnModel usageTxnModel = UsageTxnModel(qrData: data,
          status: 3,
          entryDateTime: DateTime.now().microsecondsSinceEpoch,
          exitDateTime: DateTime.now().microsecondsSinceEpoch);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanDataPage(usageTxnModel: usageTxnModel),
        ),
      ).then((_) {
        // Reset navigating flag when returning from the next page
        setState(() {
          navigating = false;
        });
        controller?.resumeCamera();
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}