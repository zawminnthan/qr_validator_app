class PayloadData {
  final String payloadHashMac;
  final dynamic payload;

  PayloadData({
    required this.payloadHashMac,
    required this.payload,
  });

  factory PayloadData.fromJson(Map<String, dynamic> json) {
    return PayloadData(
      payloadHashMac: json['payloadHashMac'],
      payload: json['payload'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payloadHashMac': payloadHashMac,
      'payload': payload,
    };
  }
}