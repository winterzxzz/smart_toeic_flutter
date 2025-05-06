import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/auth_text_field.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/login/login_cubit.dart';
import 'package:toeic_desktop/ui/page/login/login_navigator.dart';
import 'package:toeic_desktop/ui/page/login/login_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<LoginCubit>(),
      child: Page(),
    );
  }
}

class Page extends StatefulWidget {
  const Page({
    super.key,
  });

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController()
      ..addListener(() => setState(() {}));
    passwordController = TextEditingController()
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onLoginSuccess() {
    AppRouter.clearAndNavigate(AppRouter.bottomTab);
  }

  bool _isLoginButtonEnabled() {
    return emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final navigator = LoginNavigator(context: context);
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.failure) {
          navigator.error(state.errorMessage);
        }
        if (state.loadStatus == LoadStatus.success) {
          showToast(title: 'Welcome back!', type: ToastificationType.success);
          _onLoginSuccess();
        }
      },
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to Smart TOEIC Prep',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Login to access our comprehensive TOEIC preparation resources',
                    style: TextStyle(color: AppColors.textGray),
                  ),
                  const SizedBox(height: 24),
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AuthTextField(
                          controller: emailController,
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        AuthTextField(
                          controller: passwordController,
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          keyboardType: TextInputType.visiblePassword,
                          isPassword: true,
                        ),
                        const SizedBox(height: 24),
                        BlocSelector<LoginCubit, LoginState, bool>(
                          selector: (state) =>
                              state.loadStatus == LoadStatus.loading,
                          builder: (context, isLoading) {
                            return CustomButton(
                              text: 'Login',
                              onPressed: _isLoginButtonEnabled()
                                  ? () {
                                      context.read<LoginCubit>().login(
                                            emailController.text.trim(),
                                            passwordController.text.trim(),
                                          );
                                    }
                                  : null,
                              isLoading: isLoading,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        // Register
                        GestureDetector(
                          onTap: () {
                            navigator.navigateToRegister();
                          },
                          child: const Text.rich(
                            TextSpan(
                              text: 'Don\'t have an account? ',
                              children: [
                                TextSpan(
                                  text: 'Register',
                                  style: TextStyle(
                                    color: AppColors.textBlue,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.textBlue,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                            onPressed: () {
                              navigator.navigateToResetPassword();
                            },
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: AppColors.textBlue,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.textBlue,
                              ),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SocialButtons extends StatelessWidget {
  const SocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: SizedBox(
            height: 45,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.facebook,
                    color: AppColors.textWhite,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Facebook',
                    style: TextStyle(color: AppColors.textWhite),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SizedBox(
            height: 45,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.google,
                    color: AppColors.textWhite,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Google',
                    style: TextStyle(color: AppColors.textWhite),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
