import 'ticket_info.dart';

class UpdateTicketStatus {
  final String tktSlNo;
  final int opId;
  final List<TicketInfo> ticketInfo;

  UpdateTicketStatus({
    required this.tktSlNo,
    required this.opId,
    required this.ticketInfo,
  });

  factory UpdateTicketStatus.fromJson(Map<String, dynamic> json) {

    var ticketInfoFromJson = json['ticketInfo'] as List;
    List<TicketInfo> ticketInfoList = ticketInfoFromJson.map((i) => TicketInfo.fromJson(i)).toList();

    return UpdateTicketStatus(
      tktSlNo: json['tktSlNo'],
      opId: json['opId'],
      ticketInfo: ticketInfoList,
    );
  }


  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> ticketInfoList = ticketInfo.map((i) => i.toJson()).toList();
    return {
      'tktSlNo': tktSlNo,
      'opId': opId,
      'ticketInfo': ticketInfoList,
    };
  }
}