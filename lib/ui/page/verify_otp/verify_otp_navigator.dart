import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';

class VerifyOtpNavigator extends AppNavigator {
  VerifyOtpNavigator({required super.context});

  void navigateToHome() {
    // Navigate to the main screen, removing all previous routes
    AppRouter.clearAndNavigate(AppRouter.bottomTab);
  }
}
