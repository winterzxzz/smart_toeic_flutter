import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'package:toeic_desktop/ui/page/verify_otp/verify_otp_cubit.dart';
import 'package:toeic_desktop/ui/page/verify_otp/verify_otp_navigator.dart';
import 'package:toeic_desktop/ui/page/verify_otp/verify_otp_state.dart';

class VerifyOtpPage extends StatelessWidget {
  final String verificationKey;
  final String email;

  const VerifyOtpPage({
    super.key,
    required this.verificationKey,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          injector<VerifyOtpCubit>()..requestOtp(verificationKey, email),
      child: const _VerifyOtpView(),
    );
  }
}

class _VerifyOtpView extends StatefulWidget {
  const _VerifyOtpView();

  @override
  State<_VerifyOtpView> createState() => _VerifyOtpViewState();
}

class _VerifyOtpViewState extends State<_VerifyOtpView> {
  late TextEditingController otpController;

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController()..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  bool _isVerifyButtonEnabled() {
    return otpController.text.length == 6;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final navigator = VerifyOtpNavigator(context: context);

    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: textTheme.titleMedium,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gray2),
      ),
    );

    return BlocListener<VerifyOtpCubit, VerifyOtpState>(
      listenWhen: (previous, current) =>
          previous.verifyOtpStatus != current.verifyOtpStatus,
      listener: (context, state) {
        if (LoadStatus.success == state.verifyOtpStatus) {
          navigator.navigateToHome();
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
                    S.current.app_name,
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
                    buildWhen: (previous, current) =>
                        previous.requestOtpStatus != current.requestOtpStatus ||
                        previous.email != current.email,
                    builder: (context, state) {
                      if (state.requestOtpStatus == LoadStatus.loading) {
                        return Column(
                          children: [
                            const CircularProgressIndicator(),
                            const SizedBox(height: 16),
                            Text(
                              'Sending OTP to your email...',
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppColors.textGray,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      }
                      return Text(
                        'Enter the OTP code sent to ${state.email}',
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.textGray,
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Pinput(
                    controller: otpController,
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        border: Border.all(color: AppColors.primary),
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        border: Border.all(color: Colors.red),
                      ),
                    ),
                    pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                    showCursor: true,
                    onCompleted: (pin) {
                      context.read<VerifyOtpCubit>().verifyOtp(pin);
                    },
                  ),
                  const SizedBox(height: 24),
                  BlocSelector<VerifyOtpCubit, VerifyOtpState, bool>(
                    selector: (VerifyOtpState state) =>
                        state.verifyOtpStatus == LoadStatus.loading,
                    builder: (context, isLoading) {
                      return CustomButton(
                        width: double.infinity,
                        onPressed: _isVerifyButtonEnabled()
                            ? () {
                                context.read<VerifyOtpCubit>().verifyOtp(
                                      otpController.text.trim(),
                                    );
                              }
                            : null,
                        isLoading: isLoading,
                        child: const Text('Verify'),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<VerifyOtpCubit, VerifyOtpState>(
                    builder: (context, state) {
                      return GestureDetector(
                        onTap: state.requestOtpStatus == LoadStatus.loading
                            ? null
                            : () {
                                context.read<VerifyOtpCubit>().requestOtp(
                                      state.key,
                                      state.email,
                                    );
                              },
                        child: Text(
                          'Resend Code',
                          style: textTheme.bodyMedium?.copyWith(
                            color: state.requestOtpStatus == LoadStatus.loading
                                ? AppColors.textGray
                                : AppColors.textBlue,
                            decoration: TextDecoration.underline,
                            decorationColor:
                                state.requestOtpStatus == LoadStatus.loading
                                    ? AppColors.textGray
                                    : AppColors.textBlue,
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      navigator.pop();
                    },
                    child: Text.rich(TextSpan(
                      text: 'Go back to ',
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
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
