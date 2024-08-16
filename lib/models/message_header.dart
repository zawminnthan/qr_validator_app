class MessageHeader {
  int messageType;
  int messageFormatVer;
  int messageRecordSize;
  int messageSequenceNumber;
  String txnDateTime;
  int deviceOwnerId;
  int locationId;
  int deviceType;
  int deviceSequenceNumber;
  String equipmentNumber;
  int lineId;

  MessageHeader({
    required this.messageType,
    required this.messageFormatVer,
    required this.messageRecordSize,
    required this.messageSequenceNumber,
    required this.txnDateTime,
    required this.deviceOwnerId,
    required this.locationId,
    required this.deviceType,
    required this.deviceSequenceNumber,
    required this.equipmentNumber,
    required this.lineId,
  });

  factory MessageHeader.fromJson(Map<String, dynamic> json) {
    return MessageHeader(
      messageType: json['messageType'],
      messageFormatVer: json['messageFormatVersion'],
      messageRecordSize: json['messageRecordSize'],
      messageSequenceNumber: json['messageSequenceNumber'],
      txnDateTime: json['transactionDateTime'],
      deviceOwnerId: json['deviceOwnerId'],
      locationId: json['locationId'],
      deviceType: json['deviceType'],
      deviceSequenceNumber: json['deviceSequenceNumber'],
      equipmentNumber: json['equipmentNumber'],
      lineId: json['lineId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageType': messageType,
      'messageFormatVersion': messageFormatVer,
      'messageRecordSize': messageRecordSize,
      'messageSequenceNumber': messageSequenceNumber,
      'transactionDateTime': txnDateTime,
      'deviceOwnerId': deviceOwnerId,
      'locationId': locationId,
      'deviceType': deviceType,
      'deviceSequenceNumber': deviceSequenceNumber,
      'equipmentNumber': equipmentNumber,
      'lineId': lineId,
    };
  }
}