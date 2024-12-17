import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';

class LoginNavigator extends AppNavigator {
  LoginNavigator({required super.context});

  void navigateToRegister() {
    GoRouter.of(context).pushNamed(AppRouter.register);
  }

  void navigateToResetPassword() {
    GoRouter.of(context).pushNamed(AppRouter.resetPassword);
  }
}
