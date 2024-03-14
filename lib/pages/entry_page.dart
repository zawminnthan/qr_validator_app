import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_validator_app/pages/scan_data_page.dart';

class EntryPage extends StatefulWidget {
  const EntryPage({Key? key}) : super(key: key);

  @override
  State<EntryPage> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryPage> {
  Barcode? result;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool navigating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Scanner'),
      ),
      body: Column(
        children: <Widget>[
         /* if (result != null)
            Text(
                'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
          else*/
            const Text('Scan a code'),
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ScanDataPage(data: data),
        ),
      ).then((_) {
        // Reset navigating flag when returning from the next page
        setState(() {
          navigating = false;
        });
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}