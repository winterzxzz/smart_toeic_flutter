// To parse this JSON data, do
//
//     final paymentStatus = paymentStatusFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'payment_status.g.dart';

PaymentStatus paymentStatusFromJson(String str) => PaymentStatus.fromJson(json.decode(str));

String paymentStatusToJson(PaymentStatus data) => json.encode(data.toJson());

@JsonSerializable()
class PaymentStatus {
    @JsonKey(name: "return_code")
    int returnCode;
    @JsonKey(name: "return_message")
    String returnMessage;
    @JsonKey(name: "sub_return_code")
    int subReturnCode;
    @JsonKey(name: "sub_return_message")
    String subReturnMessage;
    @JsonKey(name: "is_processing")
    bool isProcessing;
    @JsonKey(name: "amount")
    int amount;
    @JsonKey(name: "zp_trans_id")
    int zpTransId;
    @JsonKey(name: "discount_amount")
    int discountAmount;

    PaymentStatus({
        required this.returnCode,
        required this.returnMessage,
        required this.subReturnCode,
        required this.subReturnMessage,
        required this.isProcessing,
        required this.amount,
        required this.zpTransId,
        required this.discountAmount,
    });

    factory PaymentStatus.fromJson(Map<String, dynamic> json) => _$PaymentStatusFromJson(json);

    Map<String, dynamic> toJson() => _$PaymentStatusToJson(this);
}
