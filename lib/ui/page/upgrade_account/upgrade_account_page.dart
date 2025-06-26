import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
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
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
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
                title: Text(S.current.upgrade_account),
                centerTitle: true,
                floating: true,
                leading: const LeadingBackButton(),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        S.current.choose_the_plan_that_s_right_for_you,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        S.current
                            .enhance_your_toeic_skills_with_unique_features,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
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
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.3),
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
                                      color: theme.colorScheme.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      S.current.premium_account,
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primary
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const FaIcon(
                                          FontAwesomeIcons.calendarDays),
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
                                              '${S.current.expiration_date}: $expiredDateString',
                                              style: theme.textTheme.bodyMedium,
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
                                  child: CustomButton(
                                    height: 50,
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
                                        const Icon(Icons.refresh),
                                        const SizedBox(width: 8),
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
                        return Column(
                          children: [
                            UpgradeAccountCard(
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
                                _upgradeAccountCubit.upgradeAccount();
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
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(
                            S.current.still_have_questions,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            S.current.contact_us_for_support,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textGray,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          CustomButton(
                            width: size.width * 0.6,
                            height: 50,
                            onPressed: () {
                              _upgradeAccountCubit.mailTo();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.support_agent,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  S.current.contact_support,
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
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
