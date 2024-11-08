import 'package:go_router/go_router.dart';
import 'package:iscanner_app/app.dart';
import 'package:iscanner_app/common/router/route_config.dart';
import 'package:iscanner_app/ui/common/app_navigator.dart';
import 'package:iscanner_app/ui/page/bottom_tab/bottom_tab_cubit.dart';

class LoginNavigator extends AppNavigator {
  LoginNavigator({required super.context});

  void navigateToRegister() {
    injector<BottomTabCubit>().updateIndex(6);
  }

  void navigateToResetPassword() {
    GoRouter.of(context).pushNamed(AppRouter.resetPassword);
  }
}
