import 'package:toeic_desktop/data/models/entities/payment/payment_status.dart';
import 'package:toeic_desktop/data/models/entities/profile/user_entity.dart';

class PaymentUserStatus {
  final PaymentStatus payment;
  final UserEntity user;

  PaymentUserStatus(this.payment, this.user);
}
