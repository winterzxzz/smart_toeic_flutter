// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentStatus _$PaymentStatusFromJson(Map<String, dynamic> json) =>
    PaymentStatus(
      returnCode: (json['return_code'] as num).toInt(),
      returnMessage: json['return_message'] as String,
      subReturnCode: (json['sub_return_code'] as num).toInt(),
      subReturnMessage: json['sub_return_message'] as String,
      isProcessing: json['is_processing'] as bool,
      amount: (json['amount'] as num).toInt(),
      zpTransId: (json['zp_trans_id'] as num).toInt(),
      discountAmount: (json['discount_amount'] as num).toInt(),
    );

Map<String, dynamic> _$PaymentStatusToJson(PaymentStatus instance) =>
    <String, dynamic>{
      'return_code': instance.returnCode,
      'return_message': instance.returnMessage,
      'sub_return_code': instance.subReturnCode,
      'sub_return_message': instance.subReturnMessage,
      'is_processing': instance.isProcessing,
      'amount': instance.amount,
      'zp_trans_id': instance.zpTransId,
      'discount_amount': instance.discountAmount,
    };
