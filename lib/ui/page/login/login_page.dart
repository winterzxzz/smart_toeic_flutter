import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/common/utils/biometric_helper.dart';
import 'package:toeic_desktop/data/database/secure_storage_helper.dart';
import 'package:toeic_desktop/data/models/entities/auth/auth_response.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';
import 'package:toeic_desktop/ui/common/widgets/auth_text_field.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'package:toeic_desktop/ui/page/login/login_cubit.dart';
import 'package:toeic_desktop/ui/page/login/login_navigator.dart';
import 'package:toeic_desktop/ui/page/login/login_state.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<LoginCubit>(),
      child: const _LoginPageContent(),
    );
  }
}

class _LoginPageContent extends StatefulWidget {
  const _LoginPageContent();

  @override
  State<_LoginPageContent> createState() => _LoginPageContentState();
}

class _LoginPageContentState extends State<_LoginPageContent> {
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

  bool _isLoginButtonEnabled() {
    return emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  Future<void> _showBiometricSetupDialog() async {
    final canUseBiometric = await BiometricHelper.instance.canCheckBiometrics();
    final isDeviceSupported =
        await BiometricHelper.instance.isDeviceSupported();

    if (!canUseBiometric || !isDeviceSupported) {
      // Device doesn't support biometric, go directly to home
      if (mounted) {
        GoRouter.of(context).goNamed(AppRouter.bottomTab);
      }
      return;
    }

    if (!mounted) return;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Đăng nhập sinh trắc học'),
        content: const Text(
          'Bạn có muốn bật đăng nhập bằng vân tay/Face ID cho lần sau không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Không'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Bật'),
          ),
        ],
      ),
    );

    if (result == true) {
      await SecureStorageHelper.instance.setBiometricEnabled(true);
      showToast(
        title: 'Đã bật đăng nhập sinh trắc học',
        type: ToastificationType.success,
      );
    }

    if (mounted) {
      GoRouter.of(context).goNamed(AppRouter.bottomTab);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final navigator = LoginNavigator(context: context);
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.success) {
          _showBiometricSetupDialog();
        }
        if (state.authChallenge != null &&
            state.authChallenge is AuthChallenge) {
          final challenge = state.authChallenge as AuthChallenge;
          // Navigate to waiting verify page
          GoRouter.of(context).pushNamed(AppRouter.waitingVerify);

          showToast(
            title: challenge.message,
            type: ToastificationType.info,
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    AppImages.appLogo,
                    width: 200,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    S.current.login_title,
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    S.current.login_description,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AuthTextField(
                          controller: emailController,
                          labelText: S.current.email_label,
                          hintText: S.current.email_hint,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        AuthTextField(
                          controller: passwordController,
                          labelText: S.current.password_label,
                          hintText: S.current.password_hint,
                          keyboardType: TextInputType.visiblePassword,
                          isPassword: true,
                        ),
                        const SizedBox(height: 24),
                        BlocSelector<LoginCubit, LoginState, bool>(
                          selector: (state) =>
                              state.loadStatus == LoadStatus.loading,
                          builder: (context, isLoading) {
                            return CustomButton(
                              width: double.infinity,
                              onPressed: _isLoginButtonEnabled()
                                  ? () {
                                      context.read<LoginCubit>().login(
                                            emailController.text.trim(),
                                            passwordController.text.trim(),
                                          );
                                    }
                                  : null,
                              isLoading: isLoading,
                              child: Text(S.current.login_button),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        // Register
                        GestureDetector(
                          onTap: () {
                            navigator.navigateToRegister();
                          },
                          child: Text.rich(
                            TextSpan(
                              text: '${S.current.dont_have_account} ',
                              children: [
                                TextSpan(
                                  text: S.current.register_button,
                                  style: textTheme.bodyMedium?.copyWith(
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
                            child: Text(
                              S.current.forgot_password,
                              style: textTheme.bodyMedium?.copyWith(
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
