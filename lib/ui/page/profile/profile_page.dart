import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/common/utils/utils.dart';
import 'package:toeic_desktop/data/models/entities/profile/user_entity.dart';
import 'package:toeic_desktop/data/models/enums/profile_menu_button.dart';
import 'package:toeic_desktop/data/models/request/profile_update_request.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/confirm_dia_log.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'package:toeic_desktop/ui/page/profile/widgets/avatar_heading.dart';
import 'package:toeic_desktop/ui/page/profile/widgets/profile_divider.dart';
import 'package:toeic_desktop/ui/page/profile/widgets/target_score.dart';
import 'package:toeic_desktop/ui/page/profile/widgets/update_profile_form.dart';
import 'package:toeic_desktop/ui/page/profile/widgets/update_target_score_form.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return const Page();
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
  late final UserCubit userCubit;
  @override
  void initState() {
    super.initState();
    userCubit = injector<UserCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            title: Text(
              S.current.profile,
              style: theme.textTheme.titleMedium,
            ),
            actions: [
              PopupMenuButton(
                color: theme.appBarTheme.backgroundColor,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 150),
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding: const EdgeInsets.all(16),
                  child:
                      const FaIcon(FontAwesomeIcons.ellipsisVertical, size: 16),
                ),
                onSelected: (value) {
                  switch (value) {
                    case ProfileMenuButton.settings:
                      GoRouter.of(context).pushNamed(AppRouter.setting);
                      break;
                    case ProfileMenuButton.targetScore:
                      showUpdateTargetDialog();
                      break;
                    case ProfileMenuButton.history:
                      GoRouter.of(context).pushNamed(AppRouter.historyTest);
                      break;
                    case ProfileMenuButton.analysis:
                      GoRouter.of(context).pushNamed(AppRouter.analysis);
                      break;
                    case ProfileMenuButton.logout:
                      showConfirmDialog(
                        context,
                        ProfileMenuButton.logout.getTitle(),
                        S.current.are_you_sure,
                        () {
                          userCubit.removeUser(context);
                        },
                      );
                      break;
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: ProfileMenuButton.settings,
                    child: Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.gear,
                          size: 14,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          ProfileMenuButton.settings.getTitle(),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: ProfileMenuButton.targetScore,
                    child: Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.chartLine,
                          size: 14,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          ProfileMenuButton.targetScore.getTitle(),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: ProfileMenuButton.history,
                    child: Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.clockRotateLeft,
                          size: 14,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          ProfileMenuButton.history.getTitle(),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: ProfileMenuButton.analysis,
                    child: Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.chartLine,
                          size: 14,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          ProfileMenuButton.analysis.getTitle(),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: ProfileMenuButton.logout,
                    child: Row(
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.rightFromBracket,
                          color: AppColors.error,
                          size: 14,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          ProfileMenuButton.logout.getTitle(),
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: BlocSelector<UserCubit, UserState, UserEntity?>(
                selector: (state) {
                  return state.user;
                },
                builder: (context, user) {
                  return Column(
                    children: [
                      const SizedBox(height: 16),
                      const AvatarHeading(),
                      const SizedBox(height: 8),
                      Text(
                        user?.name ?? '',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        user?.email ?? '',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const ProfileDivider(
                        height: 24,
                      ),
                      Column(
                        children: [
                          TargetScoreWidget(
                            title:
                                '${S.current.reading_current} / ${S.current.reading_target}',
                            targetScore: user?.targetScore?.reading,
                            currentScore: user?.actualScore?.reading,
                          ),
                          const SizedBox(height: 24),
                          TargetScoreWidget(
                            title:
                                '${S.current.listening_current} / ${S.current.listening_target}',
                            targetScore: user?.targetScore?.listening,
                            currentScore: user?.actualScore?.listening,
                          ),
                        ],
                      ),
                      const ProfileDivider(
                        height: 24,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: CustomButton(
                          onPressed: () {
                            showUpdateProfileForm(
                              name: user?.name,
                              bio: user?.bio,
                            );
                          },
                          child: Text(S.current.update_profile),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showUpdateTargetDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return const UpdateTargetScoreForm();
      },
    );
  }

  void showUpdateProfileForm({String? name, String? bio}) {
    Utils.showModalBottomSheetForm(
      context: context,
      title: S.current.update_profile,
      child: FormUpdateProfileWidget(
        args: FormUpdateProfileArgs(
          name: name,
          bio: bio,
          onSave: (title, description) {
            userCubit.updateProfile(ProfileUpdateRequest(
              name: title,
              bio: description,
            ));
          },
        ),
      ),
    );
  }
}
