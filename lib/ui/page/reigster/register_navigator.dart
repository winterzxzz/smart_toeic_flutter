import 'package:go_router/go_router.dart';
import 'package:iscanner_app/app.dart';
import 'package:iscanner_app/common/router/route_config.dart';
import 'package:iscanner_app/ui/common/app_navigator.dart';
import 'package:iscanner_app/ui/page/bottom_tab/bottom_tab_cubit.dart';

class RegisterNavigator extends AppNavigator {
  RegisterNavigator({required super.context});

  void navigateToLogin() {
    injector<BottomTabCubit>().updateIndex(5);
  }

  void navigateToResetPassword() {
    GoRouter.of(context).pushNamed(AppRouter.resetPassword);
  }
}
