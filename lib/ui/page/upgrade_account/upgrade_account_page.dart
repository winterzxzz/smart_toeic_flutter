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
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: MediaQuery.sizeOf(context).width * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Center(
                    child: Text(
                      'Chọn gói dịch vụ phù hợp với bạn',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Nâng cao kỹ năng TOEIC của bạn với các tính năng độc đáo',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textGray),
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<UserCubit, UserState>(builder: (context, state) {
                    final isPremium = state.user?.isPremium() ?? false;
                    if (!isPremium) {
                    return const SizedBox.shrink();
                    }
                      return Center(
                        child: Column(
                          children: [
                            Card(
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text.rich(
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      TextSpan(
                                        children: [
                                          TextSpan(text: 'Trạng thái: '),
                                          TextSpan(text: 'Premium', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.success)),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: AppColors.buttonBorder),
                                      ),
                                      child: Row(
                                        children: [
                                          FaIcon(FontAwesomeIcons.calendarDays),
                                          const SizedBox(width: 8),
                                          Builder(
                                            builder: (context) {
                                              // Parse ISO date string to DateTime
                                              final DateTime expiredDate = DateTime.parse(state.user!.upgradeExpiredDate!);
                                              // Format date to desired display format
                                              final String expiredDateString = DateFormat('dd/MM/yyyy').format(expiredDate);
                                              return Text('Ngày hết hạn: $expiredDateString');
                                            }
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    // Gia han
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          context.read<UpgradeAccountCubit>().upgradeAccount();
                                        },
                                        child: const Text('Gia hạn'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      );
                  }),
                  const SizedBox(height: 32),
                  BlocBuilder<UserCubit, UserState>(
                    builder: (context, state) {
                      final isPremium = state.user?.isPremium() ?? false;
                      return Row(
                        children: [
                          Expanded(
                            child: UpgradeAccountCard(
                              title: 'Gói Miễn phí',
                              price: '0 VND',
                              features: [
                                'Làm bài thi TOEIC',
                                'Chấm điểm và lưu kết quả',
                                'Tạo bộ flashcard',
                                'Truy cập flashcards có sẵn',
                                'Truy cập blog',
                                'Điền tự động bằng AI',
                                'Lời giải AI cho câu hỏi',
                                'Phân tích chỉ số cá nhân',
                                'Trắc nghiệm và nhắc nhở',
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
                              isCurrentPlan: isPremium == false,
                              onPressed: null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: UpgradeAccountCard(
                              title: 'Gói Nâng cấp',
                              price: '5.000 VND',
                              features: [
                              'Làm bài thi TOEIC',
                              'Chấm điểm và lưu kết quả',
                              'Tạo bộ flashcard',
                              'Truy cập flashcards có sẵn',
                              'Truy cập blog',
                              'Điền tự động bằng AI',
                              'Lời giải AI cho câu hỏi',
                              'Phân tích chỉ số cá nhân',
                              'Trắc nghiệm và nhắc nhở',
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
                            isCurrentPlan: isPremium == true,
                            onPressed: () {
                              context
                                  .read<UpgradeAccountCubit>()
                                  .upgradeAccount();
                            },
                          )),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Vẫn còn thắc mắc?',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Liên hệ với chúng tôi để được hỗ trợ',
                          style: TextStyle(color: AppColors.textGray),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            // Handle contact support action
                          },
                          child: Text('Liên hệ hỗ trợ'),
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
        title: 'Không thể mở URL',
        type: ToastificationType.error,
      );
    }
  }
}
