class QrCodeTicketDataHeader {
  int formatVersion;
  int projectId;
  String qrProductNumber;
  String qrTicketNumber;
  String shardingId;
  dynamic businessDate;
  int qrMediaTypeId;
  int acquirerId;
  int agentId;
  String operatorReferenceData;

  QrCodeTicketDataHeader({
    required this.formatVersion,
    required this.projectId,
    required this.qrProductNumber,
    required this.qrTicketNumber,
    required this.shardingId,
    this.businessDate,
    required this.qrMediaTypeId,
    required this.acquirerId,
    required this.agentId,
    required this.operatorReferenceData,
  });

  factory QrCodeTicketDataHeader.fromJson(Map<String, dynamic> json) {
    return QrCodeTicketDataHeader(
      formatVersion: json['formatVersion'],
      projectId: json['projectId'],
      qrProductNumber: json['qrProductNumber'],
      qrTicketNumber: json['qrTicketNumber'],
      shardingId: json['shardingId'],
      businessDate: json['businessDate'],
      qrMediaTypeId: json['qrMediaTypeId'],
      acquirerId: json['acquirerId'],
      agentId: json['agentId'],
      operatorReferenceData: json['operatorReferenceData'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'formatVersion': formatVersion,
      'projectId': projectId,
      'qrProductNumber': qrProductNumber,
      'qrTicketNumber': qrTicketNumber,
      'shardingId': shardingId,
      'businessDate': businessDate,
      'qrMediaTypeId': qrMediaTypeId,
      'acquirerId': acquirerId,
      'agentId': agentId,
      'operatorReferenceData': operatorReferenceData,
    };
  }
}