import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/reset_password/reset_password_navigator.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final navigator = ResetPasswordNavigator(context: context);
    return Scaffold(
      body: SizedBox(
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
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        labelStyle: TextStyle(color: AppColors.textGray),
                        hintStyle: TextStyle(
                          color: AppColors.textGray,
                          fontWeight: FontWeight.w400,
                        ),
                        border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: AppColors.gray1, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.textBlue,
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
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Send',
                          style: TextStyle(color: AppColors.textWhite),
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
    );
  }
}
