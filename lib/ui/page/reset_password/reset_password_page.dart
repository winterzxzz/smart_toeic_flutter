import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';
import 'package:toeic_desktop/ui/common/widgets/auth_text_field.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'package:toeic_desktop/ui/page/reset_password/reset_password_cubit.dart';
import 'package:toeic_desktop/ui/page/reset_password/reset_password_navigator.dart';
import 'package:toeic_desktop/ui/page/reset_password/reset_password_state.dart';

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<ResetPasswordCubit>(),
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
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController()
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _isResetPasswordButtonEnabled() {
    return _emailController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final navigator = ResetPasswordNavigator(context: context);
    return BlocBuilder<ResetPasswordCubit, ResetPasswordState>(
      builder: (context, state) {
        return Scaffold(
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
                      S.current.reset_password_title,
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      S.current.reset_password_description,
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
                            controller: _emailController,
                            labelText: S.current.email_label,
                            hintText: S.current.email_hint,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          const SizedBox(height: 24),
                          BlocSelector<ResetPasswordCubit, ResetPasswordState,
                              bool>(
                            selector: (ResetPasswordState state) =>
                                state.loadStatus == LoadStatus.loading,
                            builder: (context, isLoading) {
                              return CustomButton(
                                width: double.infinity,
                                onPressed: _isResetPasswordButtonEnabled()
                                    ? () {
                                        context
                                            .read<ResetPasswordCubit>()
                                            .resetPassword(
                                              _emailController.text.trim(),
                                            );
                                      }
                                    : null,
                                isLoading: isLoading,
                                child: Text(S.current.send_button),
                              );
                            },
                          ),
                          const SizedBox(height: 24),
                          TextButton(
                            onPressed: () {
                              navigator.navigateToLogin();
                            },
                            child: Text(
                              S.current.back_to_login,
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppColors.textBlue,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.textBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
