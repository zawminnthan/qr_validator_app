import 'message_header.dart';
import 'qr_code_header.dart';

class EntryModel {
  MessageHeader messageHeader;
  QrCodeTicketDataHeader qrCodeTicketDataHeader;
  int formatVersion;
  int upgradeIndicator;
  int degradeModeId;
  int waiverFlag;
  int entryExitStatus;
  int validatedOffline;
  int ticketInfoId;

  EntryModel({
    required this.messageHeader,
    required this.qrCodeTicketDataHeader,
    required this.formatVersion,
    required this.upgradeIndicator,
    required this.degradeModeId,
    required this.waiverFlag,
    required this.entryExitStatus,
    required this.validatedOffline,
    required this.ticketInfoId,
  });

  factory EntryModel.fromJson(Map<String, dynamic> json) {
    return EntryModel(
        messageHeader: MessageHeader.fromJson(json['messageHeader']),
        qrCodeTicketDataHeader: QrCodeTicketDataHeader.fromJson(
            json['qrCodeTicketDataHeader']),
        formatVersion: json['messageFormatVersion'],
        upgradeIndicator: json['upgradeIndicator'],
        degradeModeId: json['degradeModeId'],
        waiverFlag: json['waiverFlag'],
        entryExitStatus: json['entryExitStatus'],
        validatedOffline: json['validatedOffline'],
        ticketInfoId: json['ticketInfoId']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageHeader': messageHeader.toJson(),
      'qrCodeTicketDataHeader': qrCodeTicketDataHeader.toJson(),
      'messageFormatVersion': formatVersion,
      'upgradeIndicator': upgradeIndicator,
      'degradeModeId': degradeModeId,
      'waiverFlag': waiverFlag,
      'entryExitStatus': entryExitStatus,
      'validatedOffline': validatedOffline,
      'ticketInfoId' : ticketInfoId,
    };
  }
}