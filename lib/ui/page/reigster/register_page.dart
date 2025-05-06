import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
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
  late TextEditingController nameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    nameController = TextEditingController();
    passwordController = TextEditingController();
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
        if (LoadStatus.loading == state.loadDataStatus) {
          navigator.showLoadingOverlay();
        } else {
          navigator.hideLoadingOverlay();
        }
        if (LoadStatus.failure == state.loadDataStatus) {
          showToast(title: state.message, type: ToastificationType.error);
        }
        if (LoadStatus.success == state.loadDataStatus) {
          showToast(title: state.message, type: ToastificationType.success);
          navigator.navigateToLogin();
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
                    'Welcome to TOEIC Prep',
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
                          controller: nameController,
                          labelText: 'Name',
                          hintText: 'Enter your name',
                          keyboardType: TextInputType.text,
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
                        CustomButton(
                          text: 'Sign up',
                          onPressed: _isRegisterButtonEnabled()
                              ? () {
                                  context.read<RegisterCubit>().register(
                                        emailController.text,
                                        nameController.text,
                                        passwordController.text,
                                      );
                                }
                              : null,
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            navigator.navigateToLogin();
                          },
                          child: const Text.rich(TextSpan(
                            text: 'Already have an account? ',
                            children: [
                              TextSpan(
                                text: 'Login',
                                style: TextStyle(
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
