import 'message_header.dart';
import 'qr_code_header.dart';

class PreparedPayWithHostedSession {
  String sessionId;
  String merchantId;
  String orderId;
  String transactionId;

  PreparedPayWithHostedSession({
    required this.sessionId,
    required this.merchantId,
    required this.orderId,
    required this.transactionId,
  });

  factory PreparedPayWithHostedSession.fromJson(Map<String, dynamic> json) {
    return PreparedPayWithHostedSession(
        sessionId: json['sessionId'],
        merchantId: json['merchantId'],
        orderId: json['orderId'],
        transactionId: json['transactionId']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'merchantId': merchantId,
      'orderId': orderId,
      'transactionId': transactionId,
    };
  }
}