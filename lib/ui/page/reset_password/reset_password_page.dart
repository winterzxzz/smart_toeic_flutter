import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/reset_password/reset_password_cubit.dart';
import 'package:toeic_desktop/ui/page/reset_password/reset_password_navigator.dart';
import 'package:toeic_desktop/ui/page/reset_password/reset_password_state.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<ResetPasswordCubit>(),
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
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigator = ResetPasswordNavigator(context: context);
    return BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.loading) {
          navigator.showLoadingOverlay();
        } else {
          navigator.hideLoadingOverlay();
          if (state.loadStatus == LoadStatus.failure) {
            showToast(
              title: state.message,
              type: ToastificationType.error,
            );
          } else if (state.loadStatus == LoadStatus.success) {
            showToast(
              title: state.message,
              type: ToastificationType.success,
            );
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Card(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Reset your password',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Enter your email and we will send you a link to reset your password',
                    style: TextStyle(color: AppColors.textGray),
                  ),
                  const SizedBox(height: 24),
                  Form(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your email',
                              labelStyle: TextStyle(color: AppColors.textGray),
                              hintStyle: TextStyle(
                                color: AppColors.textGray,
                                fontWeight: FontWeight.w400,
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? AppColors.primary
                                      : AppColors.textWhite,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                context
                                    .read<ResetPasswordCubit>()
                                    .resetPassword(
                                      _emailController.text,
                                    );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                'Send',
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextButton(
                            onPressed: () {
                              navigator.navigateToLogin();
                            },
                            child: const Text(
                              'Back to login',
                              style: TextStyle(
                                color: AppColors.textBlue,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.textBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
