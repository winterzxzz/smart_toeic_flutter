// To parse this JSON data, do
//
//     final payment = paymentFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'payment.g.dart';

Payment paymentFromJson(String str) => Payment.fromJson(json.decode(str));

String paymentToJson(Payment data) => json.encode(data.toJson());

@JsonSerializable()
class Payment {
    @JsonKey(name: "return_code")
    int returnCode;
    @JsonKey(name: "return_message")
    String returnMessage;
    @JsonKey(name: "sub_return_code")
    int subReturnCode;
    @JsonKey(name: "sub_return_message")
    String subReturnMessage;
    @JsonKey(name: "zp_trans_token")
    String zpTransToken;
    @JsonKey(name: "order_url")
    String orderUrl;
    @JsonKey(name: "order_token")
    String orderToken;
    @JsonKey(name: "trans_id")
    String transId;

    Payment({
        required this.returnCode,
        required this.returnMessage,
        required this.subReturnCode,
        required this.subReturnMessage,
        required this.zpTransToken,
        required this.orderUrl,
        required this.orderToken,
        required this.transId,
    });

    factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

    Map<String, dynamic> toJson() => _$PaymentToJson(this);
}
