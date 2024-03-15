import 'json_property_name.dart';

class ResponseModel{

  final String responseCode;
  final String responseMsg;
  final dynamic responseData;

  ResponseModel({
    required this.responseCode,
    required this.responseMsg,
    required this.responseData,
  });

  ResponseModel.fromJson(Map<String, dynamic> json)
  :responseCode=json[kResponseCode],
    responseMsg=json[kResponseMsg],
    responseData=json[kResponseData];


  Map<String, dynamic> toJson()=>{
    kResponseCode:responseCode,
    kResponseMsg:responseMsg,
    kResponseData:responseData
  };
}