import 'message_header.dart';
import 'qr_code_header.dart';

class OrderRequest {
  String redirectResponseUrl;
  String amount;
  String currency;

  OrderRequest({
    required this.redirectResponseUrl,
    required this.amount,
    required this.currency,
  });

  factory OrderRequest.fromJson(Map<String, dynamic> json) {
    return OrderRequest(
        redirectResponseUrl: json['redirectResponseUrl'],
        amount: json['amount'],
        currency: json['currency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'redirectResponseUrl': redirectResponseUrl,
      'amount': amount,
      'currency': currency,
    };
  }
}