import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/app_navigator.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/page/upgrade_account/upgrade_account_cubit.dart';
import 'package:toeic_desktop/ui/page/upgrade_account/upgrade_account_state.dart';
import 'package:toeic_desktop/ui/page/upgrade_account/widgets/upgrade_account_card.dart';

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

class Page extends StatefulWidget {
  const Page({super.key});

  @override
  State<Page> createState() => _PageState();
}

class _PageState extends State<Page> {
  late final UpgradeAccountCubit _upgradeAccountCubit;

  @override
  void initState() {
    super.initState();
    _upgradeAccountCubit = context.read<UpgradeAccountCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    final theme = context.theme;

    // Check orientation/width for responsive layout
    final isWideScreen = 1.sw > 600;

    return BlocConsumer<UpgradeAccountCubit, UpgradeAccountState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.loading) {
          AppNavigator(context: context).showLoadingOverlay();
        } else {
          AppNavigator(context: context).hideLoadingOverlay();
          if (state.loadStatus == LoadStatus.failure) {}
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                title: Text(
                  S.current.upgrade_account,
                  style:
                      TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                floating: true,
                leading: const LeadingBackButton(),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(height: 24.h),
                    Center(
                      child: Text(
                        S.current.choose_the_plan_that_s_right_for_you,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 22.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Text(
                          S.current
                              .enhance_your_toeic_skills_with_unique_features,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.textGray,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    BlocBuilder<UserCubit, UserState>(
                      builder: (context, state) {
                        final isPremium = state.user?.isPremium() ?? false;
                        if (!isPremium) {
                          return const SizedBox.shrink();
                        }
                        return Container(
                          margin: EdgeInsets.only(bottom: 24.h),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: colorScheme.primary.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      color: colorScheme.primary,
                                      size: 24.sp,
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      S.current.premium_account,
                                      style: textTheme.titleMedium?.copyWith(
                                        color: colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16.h),
                                Container(
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surface,
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: colorScheme.primary
                                          .withValues(alpha: 0.1),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.calendarDay,
                                        size: 18.sp,
                                        color: AppColors.textGray,
                                      ),
                                      SizedBox(width: 12.w),
                                      Expanded(
                                        child: Builder(
                                          builder: (context) {
                                            if (state
                                                    .user?.upgradeExpiredDate ==
                                                null) {
                                              return const SizedBox.shrink();
                                            }
                                            final DateTime expiredDate =
                                                DateTime.parse(state
                                                    .user!.upgradeExpiredDate!);
                                            final String expiredDateString =
                                                DateFormat('dd/MM/yyyy')
                                                    .format(expiredDate);
                                            return Text(
                                              '${S.current.expiration_date}: $expiredDateString',
                                              style: textTheme.bodyMedium
                                                  ?.copyWith(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                SizedBox(
                                  width: double.infinity,
                                  child: CustomButton(
                                    height: 50.h,
                                    isLoading:
                                        state.loadStatus == LoadStatus.loading,
                                    onPressed: () {
                                      _upgradeAccountCubit.upgradeAccount();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.refresh_rounded,
                                            size: 20.sp),
                                        SizedBox(width: 8.w),
                                        Text(S.current.renew),
                                      ],
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

                        final freePlanCard = UpgradeAccountCard(
                          title: S.current.free_plan,
                          price: '0 USD',
                          features: [
                            S.current.take_toeic_tests,
                            S.current.score_and_save_results,
                            S.current.create_flashcard_sets,
                            S.current.access_existing_flashcards,
                            S.current.access_blog,
                            S.current.ai_auto_fill,
                            S.current.ai_question_explanations,
                            S.current.personal_analytics,
                            S.current.quizzes_and_reminders,
                            S.current.not_show_advertise,
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
                            false,
                            false
                          ],
                          isPremium: isPremium,
                          isCurrentPlan: !isPremium,
                          onPressed: null,
                        );

                        final premiumPlanCard = UpgradeAccountCard(
                          title: S.current.premium_plan,
                          price: '5 USD',
                          features: [
                            S.current.take_toeic_tests,
                            S.current.score_and_save_results,
                            S.current.create_flashcard_sets,
                            S.current.access_existing_flashcards,
                            S.current.access_blog,
                            S.current.ai_auto_fill,
                            S.current.ai_question_explanations,
                            S.current.personal_analytics,
                            S.current.quizzes_and_reminders,
                            S.current.not_show_advertise
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
                            true,
                            true,
                          ],
                          isPremium: isPremium,
                          isCurrentPlan: isPremium,
                          onPressed: () {
                            _upgradeAccountCubit.upgradeAccount();
                          },
                        );

                        if (isWideScreen) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: freePlanCard),
                              SizedBox(width: 24.w),
                              Expanded(child: premiumPlanCard),
                            ],
                          );
                        }

                        return Column(
                          children: [
                            freePlanCard,
                            SizedBox(height: 16.h),
                            premiumPlanCard,
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 32.h),
                    Container(
                      padding: EdgeInsets.all(24.w),
                      decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ]),
                      child: Column(
                        children: [
                          Icon(
                            Icons.help_outline_rounded,
                            size: 48.sp,
                            color: colorScheme.primary,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            S.current.still_have_questions,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            S.current.contact_us_for_support,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textGray,
                              fontSize: 14.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 24.h),
                          CustomButton(
                            width: isWideScreen ? 200.w : 0.8.sw,
                            height: 50.h,
                            onPressed: () {
                              _upgradeAccountCubit.mailTo();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.support_agent_rounded,
                                  size: 20.sp,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  S.current.contact_support,
                                  style: TextStyle(fontSize: 16.sp),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
