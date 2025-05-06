import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/ui_models/payment_return.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/check_payment_status/check_payment_status_cubit.dart';
import 'package:toeic_desktop/ui/page/check_payment_status/check_payment_status_state.dart';

class UpgradeAccountSuccessPage extends StatelessWidget {
  const UpgradeAccountSuccessPage({super.key, required this.paymentReturn});

  final PaymentReturn paymentReturn;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<CheckPaymentStatusCubit>()
        ..checkPaymentStatus(paymentReturn.apptransid),
      child: Page(),
    );
  }
}

class Page extends StatelessWidget {
  const Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckPaymentStatusCubit, CheckPaymentStatusState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.loading) {
          AppNavigator(context: context).showLoadingOverlay();
        } else {
          AppNavigator(context: context).hideLoadingOverlay();
          if (state.loadStatus == LoadStatus.success) {
            showToast(title: state.message, type: ToastificationType.success);
          } else {
            showToast(title: state.message, type: ToastificationType.error);
          }
        }
      },
      builder: (context, state) {
        if (state.loadStatus != LoadStatus.success) {
          return const SizedBox.shrink();
        }
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Congratulations Icon or Image
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 100,
                  ),
                  SizedBox(height: 24),
                  // Title Text
                  Text(
                    'Congratulations!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  // Subtitle Text
                  Text(
                    'Your account has been successfully upgraded.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                  // Call-to-Action Button
                  ElevatedButton(
                    onPressed: () {
                      // Navigate back to the home screen
                      // GoRouter.of(context).go(AppRouter.home);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Return to Home',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
