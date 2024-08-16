import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:qr_validator_app/models/exit_model.dart';
import 'package:qr_validator_app/models/payload.dart';

import 'package:qr_validator_app/models/usage_txn_model.dart';
import 'package:qr_validator_app/pages/error_page.dart';
import 'package:qr_validator_app/pages/successful_page.dart';
import 'package:qr_validator_app/service/usage_txn_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/entry_model.dart';
import '../models/message_header.dart';
import '../models/qr_code_header.dart';
import '../models/ticket_info.dart';
import '../models/update_ticket_status.dart';
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

  TextEditingController tsnController = TextEditingController();
  TextEditingController entryDatetimeController = TextEditingController();
  TextEditingController exitDatetimeController = TextEditingController();
  TextEditingController qrStatusController = TextEditingController();
  TextEditingController opIDController = TextEditingController(text: "3");
  TextEditingController additionalFareController = TextEditingController(
      text: "0");

  late MqttServerClient client;
  late SharedPreferences prefs;
  String getClientId() {
    // Create an instance of Random
    Random random = Random();
    // Generate a random integer between 0 and 99
    int randomNumber = random.nextInt(100); // 100 is exclusive
    String clientId = "validator_$randomNumber";
    developer.log("client id : $clientId");
    return clientId;
  }

  @override
  void initState() {
    super.initState();
    initMqtt();
    initData(widget.usageTxnModel);
  }


  Future<void> initMqtt() async {
    prefs = await SharedPreferences.getInstance();

    client = MqttServerClient.withPort(
        prefs.getString(kBrokerHostName)!, //SERVER_URL without 'tcp://'
        prefs.getString(kClientId)!, //CLIENT_IDENTIFIER,
        int.parse(prefs.getString(kPort)!) //PORT
    );

    client.logging(on: true);
    client.onConnected = onConnected;
    client.onDisconnected = onDisconnected;
    client.onUnsubscribed = onUnsubscribed;
    client.onSubscribed = onSubscribed;
    client.onSubscribeFail = onSubscribeFail;
    client.pongCallback = pong;
    client.keepAlivePeriod = 60;
    client.logging(on: true);
    client.setProtocolV311();
    connectMqtt();
  }

  void onConnected() {
    developer.log('MQTT_LOGS:: Connected');
  }

  void onDisconnected() {
    developer.log('MQTT_LOGS:: Disconnected');
  }

  void onSubscribed(String topic) {
    developer.log('MQTT_LOGS:: Subscribed topic: $topic');
  }

  void onSubscribeFail(String topic) {
    developer.log('MQTT_LOGS:: Failed to subscribe $topic');
  }

  void onUnsubscribed(String? topic) {
    developer.log('MQTT_LOGS:: Unsubscribed topic: $topic');
  }

  void pong() {
    developer.log('MQTT_LOGS:: Ping response client callback invoked');
  }

  Future<void> connectMqtt() async {
    
    final connMessage = MqttConnectMessage()
        .authenticateAs(prefs.getString(kUserName),prefs.getString(kPassword))
    //.withWillTopic('willtopic')
    //.withWillMessage('Will message')
        .startClean()
        .withWillQos(MqttQos.exactlyOnce);

    developer.log('MQTT_LOGS::Mosquitto client connecting....');

    client.connectionMessage = connMessage;
    try {
      await client.connect();
    } catch (e) {
      developer.log('Exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      developer.log('MQTT_LOGS::Mosquitto client connected');
    } else {
      developer.log(
          'MQTT_LOGS::ERROR Mosquitto client connection failed - disconnecting, status is ${client
              .connectionStatus}');
      client.disconnect();
    }
  }

  void subscribe(String topic) {
    developer.log('MQTT_LOGS::Subscribing to the $topic topic');
    client.subscribe(topic, MqttQos.atMostOnce);

    client.updates!.listen((List<MqttReceivedMessage<MqttMessage?>>? c) {
      final recMess = c![0].payload as MqttPublishMessage;
      final pt =
      MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      developer.log('MQTT_LOGS:: New data arrived: topic is <${c[0]
          .topic}>, payload is $pt');
    });
  }

  void publishMessage(String message, String topic) {
    try{
    developer.log('MQTT_LOGS::Subscribing to the $topic topic and message: $message');
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      client.publishMessage(topic, MqttQos.atMostOnce, builder.payload!);
    }
    }catch(e){
      developer.log('publishMessage. Exception: $e');
      errorMessage = e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text('Scanned Data'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Ticket Info',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: tsnController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'TSN',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: qrStatusController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: entryDatetimeController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Entry Datetime',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: exitDatetimeController,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Exit Datetime',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: opIDController,
                decoration: InputDecoration(
                  labelText: 'Operator Id',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: additionalFareController,
                decoration: InputDecoration(
                  labelText: 'Additional Fare',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromRGBO(82, 170, 94, 1.0),
        onPressed: () async {
          setState(() {
            _isLoading = true;
          });

          bool result = false;
          try{
            result = await validateTxn();
          }catch(e) {
            developer.log('validateTxn. Exception: $e');
            errorMessage = e.toString();
          }
          if (result) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    SuccessfulPage(status: widget.usageTxnModel.status),
              ),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ErrorPage(
                      status: widget.usageTxnModel.status,
                      message: errorMessage,
                    ),
              ),
            );
          }
          setState(() {
            _isLoading = false;
          });
        },
        label: _isLoading
            ? const CircularProgressIndicator()
            : const Text('Submit'),
        icon: const Icon(Icons.add, color: Colors.white, size: 25),
      ),
    );
  }

  void initData(UsageTxnModel req) {
    tsnController.text = decodeQRData(req.qrData);
    entryDatetimeController.text = formatDateTime(req.entryDateTime);
    exitDatetimeController.text = formatDateTime(req.exitDateTime);
    qrStatusController.text = req.status.toString();
  }

  Future<bool> validateTxn() async {

    List<TicketInfo> ticketInfoList = [];

    // Creating a TicketInfo instance
    TicketInfo ticketInfo = TicketInfo(
      qrStatus: int.parse(qrStatusController.text),
      entryDatetime: entryDatetimeController.text,
      exitDatetime: exitDatetimeController.text,
      additionalFare: int.parse(additionalFareController.text),
      ticketInfoId: 1
    );
    ticketInfoList.add(ticketInfo);

    // Creating a UpdateTicketStatus instance
    UpdateTicketStatus updateTicketStatus = UpdateTicketStatus(
      tktSlNo: tsnController.text,
      opId: int.parse(opIDController.text),
      ticketInfo: ticketInfoList,
    );

    try {
      String? url = prefs.getString("url");
      BaseAPIService.baseUrl = url!;
      ResponseModel responseModel = await BaseAPIService.post(
          updateTicketStatus.toJson(), kUpdateQRTicketStatus);

      if (responseModel.responseCode == 200) {
        if (widget.usageTxnModel.status == 2) {
          publishMessage(entryMessage(), prefs.getString(kTopicName)!);
        } else {
          publishMessage(exitMessage(), prefs.getString(kTopicName)!);
        }
        return true;
      } else {
        errorMessage = responseModel.responseMsg;
        developer.log('Transaction failed');
        throw Exception('Transaction failed');
      }
    } catch (e) {
      // Log the exception
      developer.log('Exception during transaction process: $e');
    }
    return false;
  }

  String decodeQRData(String qrData) {
    String tsn = "";
    try {
      List<String> qrDataList = qrData.split("#");
      String qrSvc = qrDataList[1];

      //String inputString = "{4}{4}{0|5|41|66879E8F400000be|66879E8F|32|0101T021642039661|9C4|0.0|0.0|0}";

      // Find the index of the last '{' and '}'
      int lastIndexOpenBrace = qrSvc.lastIndexOf('{');
      int lastIndexCloseBrace = qrSvc.lastIndexOf('}');

      if (lastIndexOpenBrace != -1 && lastIndexCloseBrace != -1) {
        // Extract content inside the last {}
        String contentInsideBraces = qrSvc.substring(
            lastIndexOpenBrace + 1, lastIndexCloseBrace);

        // Print the content inside the last {}
        print(
            contentInsideBraces); // Output: 0|5|41|66879E8F400000be|66879E8F|32|0101T021642039661|9C4|0.0|0.0|0

        // Split the string by |
        List<String> parts = contentInsideBraces.split('|');
        String tsnPart = parts[3];

        String last8DigitsBinaryStr = hexStringToBinayString(
            tsnPart.substring(tsnPart.length - 8));

        // Replace the first two characters
        String digitsBinary32BitStr = "00${last8DigitsBinaryStr.substring(2)}";
        digitsBinary32BitStr = convertIntToDigitString(
            binaryStringToLong(digitsBinary32BitStr), 10);

        String firstTwoDigits = last8DigitsBinaryStr.substring(0, 2);
        int reqSource = binaryStringToLong(firstTwoDigits);
        String strReqSource = "Undefined";
        if (reqSource == 1) {
          strReqSource = "M";
        } else if (reqSource == 2) {
          strReqSource = "W";
        } else if (reqSource == 2) {
          strReqSource = "T";
        }

        tsn = hexStringToDateString(tsnPart.substring(0, 8)) +
            strReqSource + digitsBinary32BitStr;

        // Print tsn
        print(tsn); // Output:
      }
    } catch (e) {
      // Log the exception
      developer.log('Exception during Decode process: $e');
    }
    return tsn;
  }

  String hexStringToDateString(String hexString) {
    // Convert hexadecimal string to an integer
    int hexValue = int.parse(hexString, radix: 16);

    // Convert the hex value to a DateTime object (assuming it represents Unix epoch time)
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(hexValue * 1000);

    // Format the DateTime object to "ddMMyyyyHHmmss"
    String formattedDate = DateFormat("ddMMyyyyHHmmss").format(dateTime);

    // Print the formatted date
    print(formattedDate); // Output: 05072024151943

    return formattedDate;
  }

  String hexStringToBinayString(String hexString) {
    // Convert the hex string to an integer
    int intValue = int.parse(hexString, radix: 16);

    // Convert the integer to a binary string and pad with leading zeros to ensure 32 bits
    String binaryString = intValue.toRadixString(2).padLeft(32, '0');

    // Print the binary string
    print(binaryString); // Output: 01000000000000000000000010111101

    return binaryString;
  }

  int binaryStringToLong(String binaryString) {
    // Ensure the binary string is 32 bits long by padding with leading zeros if necessary
    binaryString = binaryString.padLeft(32, '0');

    // Convert the binary string to a long integer
    int longValue = int.parse(binaryString, radix: 2);

    // Print the long value
    print(longValue); // Output: 190

    return longValue;
  }

  String convertIntToDigitString(int value, digit) {
    // Convert the number to a ten-digit string
    String digitString = value.toString().padLeft(digit, '0');

    // Print the ten-digit string
    print(digitString); // Output: 1000000190

    return digitString;
  }

  String formatDateTime(int microsecondsSinceEpoch) {
    // Create a DateTime object from microsecondsSinceEpoch
    DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(
        microsecondsSinceEpoch);

    // Format the DateTime object to the desired string format
    DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    String formattedDateTime = formatter.format(dateTime);

    return formattedDateTime;
  }

  String convertStrDateTime(int microsecondsSinceEpoch, String format) {
    // Create a DateTime object from microsecondsSinceEpoch
    DateTime dateTime = DateTime.fromMicrosecondsSinceEpoch(
        microsecondsSinceEpoch);

    // Format the DateTime object to the desired string format
    DateFormat formatter = DateFormat(format);
    String formattedDateTime = formatter.format(dateTime);

    return formattedDateTime;
  }

  String entryMessage() {
    // Create an instance of MessageHeader
    MessageHeader messageHeader = MessageHeader(
      messageType: 57361,
      messageFormatVer: 1,
      messageRecordSize: 0,
      messageSequenceNumber: 0,
      txnDateTime: convertStrDateTime(widget.usageTxnModel.entryDateTime, "yyyy-MM-dd HH:mm:ss"),
      deviceOwnerId: 1,
      locationId: 99,
      deviceType: 1,
      deviceSequenceNumber: 1,
      equipmentNumber: "5",
      lineId: 99,
    );

    // Create an instance of QrCodeTicketDataHeader
    QrCodeTicketDataHeader qrCodeTicketDataHeader = QrCodeTicketDataHeader(
      formatVersion: 1,
      projectId: 1,
      qrProductNumber: "QR SJT",
      qrTicketNumber: tsnController.text,
      businessDate: null,
      qrMediaTypeId: 0,
      acquirerId: 1,
      agentId: 1,
      operatorReferenceData: "010001000001041801437285436",
      shardingId: ""
    );

    // Create an instance of MainModel
    EntryModel entry = EntryModel(
      messageHeader: messageHeader,
      qrCodeTicketDataHeader: qrCodeTicketDataHeader,
      formatVersion: 1,
      upgradeIndicator: 1,
      degradeModeId: 1,
      waiverFlag: 0,
      entryExitStatus: 0,
      validatedOffline: 0,
      ticketInfoId: 1
    );

    PayloadData payloadData = PayloadData(payloadHashMac: "", payload: entry);
    String message = jsonEncode(payloadData.toJson());
    developer.log("entry message: $message");

    return message;
  }

  String exitMessage() {

    // Create an instance of MessageHeader
    MessageHeader messageHeader = MessageHeader(
      messageType: 57362,
      messageFormatVer: 1,
      messageRecordSize: 0,
      messageSequenceNumber: 0,
      txnDateTime: convertStrDateTime(widget.usageTxnModel.exitDateTime, "yyyy-MM-dd HH:mm:ss"),
      deviceOwnerId: 1,
      locationId: 99,
      deviceType: 1,
      deviceSequenceNumber: 1,
      equipmentNumber: "5",
      lineId: 99,
    );

    // Create an instance of QrCodeTicketDataHeader
    QrCodeTicketDataHeader qrCodeTicketDataHeader = QrCodeTicketDataHeader(
      formatVersion: 1,
      projectId: 1,
      qrProductNumber: "QR SJT",
      qrTicketNumber: tsnController.text,
      businessDate: null,
      qrMediaTypeId: 0,
      acquirerId: 1,
      agentId: 1,
      operatorReferenceData: "010001000001041801437285436",
      shardingId: "",
    );

    // Create an instance of MainModel
    ExitModel exit = ExitModel(
      messageHeader: messageHeader,
      qrCodeTicketDataHeader: qrCodeTicketDataHeader,
      formatVersion: 1,
      upgradeIndicator: 1,
      degradeModeId: 1,
      waiverFlag: 0,
      entryExitStatus: 0,
      entryLineId: 1,
      entryLocId: 10,
      fareCode: 1,
      validatedOffline: 0,
      ticketInfoId: 1
    );

    PayloadData payloadData = PayloadData(payloadHashMac: "", payload: exit);
    String message = jsonEncode(payloadData.toJson());
    developer.log("exit message: $message");
    return message;
  }
}