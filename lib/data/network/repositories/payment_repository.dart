import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:toeic_desktop/data/models/entities/payment/payment.dart';
import 'package:toeic_desktop/data/models/entities/payment/payment_status.dart';
import 'package:toeic_desktop/data/models/entities/profile/user_entity.dart';
import 'package:toeic_desktop/data/models/ui_models/payment_user_status.dart';
import 'package:toeic_desktop/data/network/api_config/api_client.dart';
import 'package:toeic_desktop/data/network/error/api_error.dart';

abstract class PaymentRepository {
  Future<Either<ApiError, Payment>> getPayment();
  Future<Either<ApiError, PaymentUserStatus>> checkPaymentStatus(String transId);
}

class PaymentRepositoryImpl extends PaymentRepository {
  final ApiClient _apiClient;

  PaymentRepositoryImpl(this._apiClient);
  @override
  Future<Either<ApiError, Payment>> getPayment() async {
    try {
      final result = await _apiClient.getPayment();
      return Right(result);
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }

  @override
  Future<Either<ApiError, PaymentUserStatus>> checkPaymentStatus(
      String transId) async {
    try {
      final result = await Future.wait([
        _apiClient.checkPaymentStatus(transId),
        _apiClient.getUser(),
      ]);
      return Right(PaymentUserStatus(
        result[0] as PaymentStatus,
        result[1] as UserEntity,
      ));
    } on DioException catch (e) {
      return Left(ApiError.fromDioError(e));
    }
  }
}
