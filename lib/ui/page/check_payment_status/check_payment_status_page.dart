import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/ui_models/payment_return.dart';
import 'package:toeic_desktop/data/services/noti_service.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/ui/page/check_payment_status/check_payment_status_cubit.dart';
import 'package:toeic_desktop/ui/page/check_payment_status/check_payment_status_state.dart';

class UpgradeAccountSuccessPage extends StatelessWidget {
  const UpgradeAccountSuccessPage({super.key, required this.payment});

  final PaymentReturn payment;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<CheckPaymentStatusCubit>()
        ..checkPaymentStatus(payment.apptransid),
      child: const Page(),
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
          AppNavigator(context: context)
              .showLoadingOverlay(message: S.current.checking_payment_status);
        } else {
          AppNavigator(context: context).hideLoadingOverlay();
          if (state.loadStatus == LoadStatus.success) {
            NotiService().showFlutterNotification(
              title: S.current.congratulations,
              content: S.current.your_account_has_been_successfully_upgraded,
            );
          } else {
            NotiService().showFlutterNotification(
              title: S.current.update_error,
              content: state.message,
            );
          }
        }
      },
      builder: (context, state) {
        if (state.loadStatus == LoadStatus.loading) {
          return const PopScope(
            canPop: false,
            child: Scaffold(
              body: LoadingCircle(),
            ),
          );
        }
        if (state.loadStatus == LoadStatus.success) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Congratulations Icon or Image
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 100,
                    ),
                    const SizedBox(height: 24),
                    // Title Text
                    Text(
                      S.current.congratulations,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    // Subtitle Text
                    Text(
                      S.current.your_account_has_been_successfully_upgraded,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    // Call-to-Action Button
                    ElevatedButton(
                      onPressed: () {
                        GoRouter.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        S.current.return_to_home,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        // Show error or fallback UI
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error,
                    color: Colors.red,
                    size: 100,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    state.message.isNotEmpty
                        ? state.message
                        : S.current
                            .an_error_occured_while_checking_payment_status,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      GoRouter.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      S.current.return_to_home,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
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
