// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      returnCode: (json['return_code'] as num).toInt(),
      returnMessage: json['return_message'] as String,
      subReturnCode: (json['sub_return_code'] as num).toInt(),
      subReturnMessage: json['sub_return_message'] as String,
      zpTransToken: json['zp_trans_token'] as String,
      orderUrl: json['order_url'] as String,
      orderToken: json['order_token'] as String,
      transId: json['trans_id'] as String,
    );

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'return_code': instance.returnCode,
      'return_message': instance.returnMessage,
      'sub_return_code': instance.subReturnCode,
      'sub_return_message': instance.subReturnMessage,
      'zp_trans_token': instance.zpTransToken,
      'order_url': instance.orderUrl,
      'order_token': instance.orderToken,
      'trans_id': instance.transId,
    };
