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
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/widgets/confirm_dia_log.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'package:toeic_desktop/ui/page/profile/widgets/avatar_heading.dart';

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
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(24),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colorScheme.primary.withValues(alpha: 0.1),
                        colorScheme.primary.withValues(alpha: 0.05),
                        const Color(0xFF6A85B6).withValues(alpha: 0.05),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _buildPopupMenu(context),
                        ],
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, 50),
                  child: const AvatarHeading(),
                ),
              ],
            ),
            const SizedBox(height: 60),
            BlocSelector<UserCubit, UserState, UserEntity?>(
              selector: (state) {
                return state.user;
              },
              builder: (context, user) {
                return Column(
                  children: [
                    Text(
                      user?.name ?? '',
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user?.email ?? '',
                      style: textTheme.bodyMedium
                          ?.copyWith(color: colorScheme.onSurfaceVariant),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          _buildSectionHeader(context, 'Statistics',
                              FontAwesomeIcons.chartSimple),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: TargetScoreWidget(
                                  title: S.current.reading,
                                  targetScore: user?.targetScore?.reading ?? 0,
                                  currentScore: user?.actualScore?.reading ?? 0,
                                  icon: FontAwesomeIcons.bookOpen,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TargetScoreWidget(
                                  title: S.current.listening,
                                  targetScore:
                                      user?.targetScore?.listening ?? 0,
                                  currentScore:
                                      user?.actualScore?.listening ?? 0,
                                  icon: FontAwesomeIcons.headphones,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: CustomButton(
                              onPressed: () {
                                showUpdateProfileForm(
                                  name: user?.name,
                                  bio: user?.bio,
                                );
                              },
                              child: Text(
                                S.current.update_profile,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
      BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    final textTheme = context.textTheme;
    final colorScheme = context.colorScheme;
    return PopupMenuButton(
      icon: const FaIcon(FontAwesomeIcons.ellipsisVertical,
          color: Colors.black, size: 20),
      color: colorScheme.surface,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        _buildPopupMenuItem(
            context, ProfileMenuButton.settings, FontAwesomeIcons.gear),
        _buildPopupMenuItem(
            context, ProfileMenuButton.targetScore, FontAwesomeIcons.bullseye),
        _buildPopupMenuItem(context, ProfileMenuButton.history,
            FontAwesomeIcons.clockRotateLeft),
        _buildPopupMenuItem(
            context, ProfileMenuButton.analysis, FontAwesomeIcons.chartLine),
        PopupMenuItem(
          value: ProfileMenuButton.logout,
          child: Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.rightFromBracket,
                color: AppColors.error,
                size: 16,
              ),
              const SizedBox(width: 12),
              Text(
                ProfileMenuButton.logout.getTitle(),
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  PopupMenuItem _buildPopupMenuItem(
      BuildContext context, ProfileMenuButton value, IconData icon) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          FaIcon(
            icon,
            size: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          const SizedBox(width: 12),
          Text(
            value.getTitle(),
            style: Theme.of(context).textTheme.bodyMedium,
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
