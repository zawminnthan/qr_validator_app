
class TicketInfo {
  final int qrStatus;
  final String entryDatetime;
  final String exitDatetime;
  final int additionalFare;
  final int ticketInfoId;

  TicketInfo({
    required this.qrStatus,
    required this.entryDatetime,
    required this.exitDatetime,
    required this.additionalFare,
    required this.ticketInfoId,
  });

  factory TicketInfo.fromJson(Map<String, dynamic> json) {
    return TicketInfo(
      qrStatus: json['qrStatus'],
      entryDatetime: json['entryDateTime'],
      exitDatetime: json['exitDateTime'],
      additionalFare: json['additionalFare'],
        ticketInfoId: json['ticketInfoId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'qrStatus': qrStatus,
      'entryDateTime': entryDatetime,
      'exitDateTime': exitDatetime,
      'additionalFare': additionalFare,
      'ticketInfoId' : ticketInfoId
    };
  }
}