import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';

class ResetPasswordNavigator extends AppNavigator {
  ResetPasswordNavigator({required super.context});

  void navigateToLogin() {
    GoRouter.of(context).pop();
  }
}
