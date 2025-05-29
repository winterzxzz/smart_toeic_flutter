import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';
import 'package:toeic_desktop/ui/common/widgets/auth_text_field.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/reigster/register_cubit.dart';
import 'package:toeic_desktop/ui/page/reigster/register_navigator.dart';
import 'package:toeic_desktop/ui/page/reigster/register_state.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<RegisterCubit>(),
      child: const Page(),
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
  late TextEditingController nameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController()
      ..addListener(() => setState(() {}));
    nameController = TextEditingController()
      ..addListener(() => setState(() {}));
    passwordController = TextEditingController()
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool _isRegisterButtonEnabled() {
    return emailController.text.isNotEmpty &&
        nameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final navigator = RegisterNavigator(context: context);
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (LoadStatus.failure == state.loadDataStatus) {
          showToast(title: state.message, type: ToastificationType.error);
        }
        if (LoadStatus.success == state.loadDataStatus) {
          showToast(title: state.message, type: ToastificationType.success);
          navigator.navigateToLogin();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    S.current.register_description,
                    style: const TextStyle(color: AppColors.textGray),
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
                          controller: nameController,
                          labelText: S.current.name_label,
                          hintText: S.current.name_hint,
                          keyboardType: TextInputType.text,
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
                        BlocSelector<RegisterCubit, RegisterState, bool>(
                          selector: (RegisterState state) =>
                              state.loadDataStatus == LoadStatus.loading,
                          builder: (context, isLoading) {
                            return CustomButton(
                              text: S.current.register_button,
                              onPressed: _isRegisterButtonEnabled()
                                  ? () {
                                      context.read<RegisterCubit>().register(
                                            emailController.text.trim(),
                                            nameController.text.trim(),
                                            passwordController.text.trim(),
                                          );
                                    }
                                  : null,
                              isLoading: isLoading,
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            navigator.navigateToLogin();
                          },
                          child: Text.rich(TextSpan(
                            text: '${S.current.already_have_account} ',
                            children: [
                              TextSpan(
                                text: S.current.login_button,
                                style: const TextStyle(
                                  color: AppColors.textBlue,
                                  decoration: TextDecoration.underline,
                                  decorationColor: AppColors.textBlue,
                                ),
                              ),
                            ],
                          )),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                            onPressed: () {
                              navigator.navigateToResetPassword();
                            },
                            child: Text(
                              S.current.forgot_password,
                              style: const TextStyle(
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
