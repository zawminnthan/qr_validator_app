import 'message_header.dart';
import 'qr_code_header.dart';

class ExitModel {
  MessageHeader messageHeader;
  QrCodeTicketDataHeader qrCodeTicketDataHeader;
  int formatVersion;
  int upgradeIndicator;
  int degradeModeId;
  int waiverFlag;
  int entryExitStatus;
  int entryLineId;
  int entryLocId;
  int fareCode;
  int validatedOffline;
  int ticketInfoId;

  ExitModel({
    required this.messageHeader,
    required this.qrCodeTicketDataHeader,
    required this.formatVersion,
    required this.upgradeIndicator,
    required this.degradeModeId,
    required this.waiverFlag,
    required this.entryExitStatus,
    required this.entryLineId,
    required this.entryLocId,
    required this.fareCode,
    required this.validatedOffline,
    required this.ticketInfoId
  });

  factory ExitModel.fromJson(Map<String, dynamic> json) {
    return ExitModel(
        messageHeader: MessageHeader.fromJson(json['messageHeader']),
        qrCodeTicketDataHeader: QrCodeTicketDataHeader.fromJson(
            json['qrCodeTicketDataHeader']),
        formatVersion: json['formatVersion'],
        upgradeIndicator: json['upgradeIndicator'],
        degradeModeId: json['degradeModeId'],
        waiverFlag: json['waiverFlag'],
        entryExitStatus: json['entryExitStatus'],
        entryLineId: json['entryLineId'],
        entryLocId: json['entryLocation'],
        fareCode: json['fareCode'],
        validatedOffline: json['validatedOffline'],
        ticketInfoId: json['ticketInfoId']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageHeader': messageHeader.toJson(),
      'qrCodeTicketDataHeader': qrCodeTicketDataHeader.toJson(),
      'formatVersion': formatVersion,
      'upgradeIndicator': upgradeIndicator,
      'degradeModeId': degradeModeId,
      'waiverFlag': waiverFlag,
      'entryExitStatus': entryExitStatus,
      'entryLineId': entryExitStatus,
      'entryLocation': entryLocId,
      'fareCode': fareCode,
      'validatedOffline': validatedOffline,
      'ticketInfoId' : ticketInfoId,
    };
  }
}