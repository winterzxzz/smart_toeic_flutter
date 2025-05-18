import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/upgrade_account/upgrade_account_cubit.dart';
import 'package:toeic_desktop/ui/page/upgrade_account/upgrade_account_state.dart';
import 'package:toeic_desktop/ui/page/upgrade_account/widgets/upgrade_account_card.dart';
import 'package:url_launcher/url_launcher.dart';

class PricingPlanScreen extends StatelessWidget {
  const PricingPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<UpgradeAccountCubit>(),
      child: const Page(),
    );
  }
}

class Page extends StatelessWidget {
  const Page({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpgradeAccountCubit, UpgradeAccountState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.loading) {
          AppNavigator(context: context).showLoadingOverlay();
        } else {
          AppNavigator(context: context).hideLoadingOverlay();
          if (state.loadStatus == LoadStatus.failure) {
            showToast(
              title: state.message,
              type: ToastificationType.error,
            );
          } else if (state.loadStatus == LoadStatus.success) {
            _launchUrl(state.payment!.orderUrl);
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: const LeadingBackButton(),
            title: const Text('Upgrade Account'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      'Choose the plan that\'s right for you',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Enhance your TOEIC skills with unique features',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textGray,
                          ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) {
                      final isPremium = state.user?.isPremium() ?? false;
                      if (!isPremium) {
                        return const SizedBox.shrink();
                      }
                      return Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.success.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: AppColors.success,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Premium Account',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: AppColors.success,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const FaIcon(FontAwesomeIcons.calendarDays),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Builder(
                                        builder: (context) {
                                          final DateTime expiredDate =
                                              DateTime.parse(state
                                                  .user!.upgradeExpiredDate!);
                                          final String expiredDateString =
                                              DateFormat('dd/MM/yyyy')
                                                  .format(expiredDate);
                                          return Text(
                                            'Expiration date: $expiredDateString',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    context
                                        .read<UpgradeAccountCubit>()
                                        .upgradeAccount();
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Renew'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) {
                      final isPremium = state.user?.isPremium() ?? false;
                      return Column(
                        children: [
                          UpgradeAccountCard(
                            title: 'Free Plan',
                            price: '0 USD',
                            features: [
                              'Take TOEIC tests',
                              'Score and save results',
                              'Create flashcard sets',
                              'Access existing flashcards',
                              'Access blog',
                              'AI auto-fill',
                              'AI question explanations',
                              'Personal analytics',
                              'Quizzes and reminders',
                            ],
                            available: [
                              true,
                              true,
                              true,
                              true,
                              true,
                              false,
                              false,
                              false,
                              false
                            ],
                            isPremium: isPremium,
                            isCurrentPlan: !isPremium,
                            onPressed: null,
                          ),
                          const SizedBox(height: 16),
                          UpgradeAccountCard(
                            title: 'Premium Plan',
                            price: '5 USD',
                            features: [
                              'Take TOEIC tests',
                              'Score and save results',
                              'Create flashcard sets',
                              'Access existing flashcards',
                              'Access blog',
                              'AI auto-fill',
                              'AI question explanations',
                              'Personal analytics',
                              'Quizzes and reminders',
                            ],
                            available: [
                              true,
                              true,
                              true,
                              true,
                              true,
                              true,
                              true,
                              true,
                              true
                            ],
                            isPremium: isPremium,
                            isCurrentPlan: isPremium,
                            onPressed: () {
                              context
                                  .read<UpgradeAccountCubit>()
                                  .upgradeAccount();
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Still have questions?',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Contact us for support',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textGray,
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Handle contact support action
                          },
                          icon: const Icon(Icons.support_agent),
                          label: const Text('Contact Support'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      showToast(
        title: 'Could not open URL',
        type: ToastificationType.error,
      );
    }
  }
}
