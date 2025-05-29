import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/entities/profile/user_entity.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/data/models/request/profile_update_request.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/confirm_dia_log.dart';
import 'package:toeic_desktop/ui/common/widgets/loading_circle.dart';
import 'package:toeic_desktop/ui/page/profile/widgets/avatar_heading.dart';
import 'package:toeic_desktop/ui/page/profile/widgets/profile_divider.dart';
import 'package:toeic_desktop/ui/page/profile/widgets/target_score.dart';
import 'package:toeic_desktop/ui/page/profile/widgets/text_field_heading.dart';
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
  late final TextEditingController emailController;
  late final TextEditingController nameController;
  late final TextEditingController bioController;
  late final UserCubit userCubit;
  @override
  void initState() {
    super.initState();
    userCubit = injector<UserCubit>();
    emailController =
        TextEditingController(text: userCubit.state.user?.email ?? '');
    nameController =
        TextEditingController(text: userCubit.state.user?.name ?? '');
    bioController =
        TextEditingController(text: userCubit.state.user?.bio ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: BlocListener<UserCubit, UserState>(
        listenWhen: (previous, current) => previous.user != current.user,
        listener: (context, state) {
          if (state.user != null) {
            emailController.text = state.user?.email ?? '';
            nameController.text = state.user?.name ?? '';
            bioController.text = state.user?.bio ?? '';
          }
        },
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              title: Text(S.current.profile),
              actions: [
                PopupMenuButton(
                  color: theme.appBarTheme.backgroundColor,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 150),
                  child: Container(
                    margin: const EdgeInsets.only(right: 16),
                    padding: const EdgeInsets.all(16),
                    child: const FaIcon(FontAwesomeIcons.ellipsisVertical,
                        size: 16),
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'settings':
                        GoRouter.of(context).pushNamed(AppRouter.setting);
                        break;
                      case 'target-score':
                        showUpdateTargetDialog();
                        break;
                      case 'history':
                        GoRouter.of(context).pushNamed(AppRouter.historyTest);
                        break;
                      case 'analysis':
                        GoRouter.of(context).pushNamed(AppRouter.analysis);
                        break;
                      case 'logout':
                        showConfirmDialog(
                          context,
                          'Logout',
                          'Are you sure?',
                          () {
                            userCubit.removeUser(context);
                          },
                        );
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'settings',
                      child: Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.gear,
                            size: 14,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Settings',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'target-score',
                      child: Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.chartLine,
                            size: 14,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Target Score',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'history',
                      child: Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.clockRotateLeft,
                            size: 14,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'History',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'analysis',
                      child: Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.chartLine,
                            size: 14,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Analysis',
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'logout',
                      child: Row(
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.rightFromBracket,
                            color: AppColors.error,
                            size: 14,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Logout',
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [
                    const AvatarHeading(),
                    const ProfileDivider(
                      height: 16,
                    ),
                    TextFieldHeading(
                      controller: emailController,
                      label: 'Email',
                      hintText: 'Enter your email',
                      icon: FontAwesomeIcons.envelope,
                      disabled: true,
                    ),
                    const SizedBox(height: 16),
                    TextFieldHeading(
                      controller: nameController,
                      label: 'Name',
                      hintText: 'Enter your name',
                      icon: FontAwesomeIcons.user,
                    ),
                    const SizedBox(height: 16),
                    TextFieldHeading(
                      controller: bioController,
                      label: 'Bio',
                      hintText: 'Enter your bio',
                      maxLines: 3,
                    ),
                    const ProfileDivider(
                      height: 16,
                    ),
                    BlocSelector<UserCubit, UserState, UserEntity?>(
                      selector: (state) {
                        return state.user;
                      },
                      builder: (context, user) {
                        return Column(
                          children: [
                            TargetScoreWidget(
                              title: 'Reading Target / Reading Current',
                              targetScore: user?.targetScore?.reading,
                            ),
                            const SizedBox(height: 16),
                            TargetScoreWidget(
                              title: 'Listening Target / Listening Current',
                              targetScore: user?.targetScore?.listening,
                            ),
                          ],
                        );
                      },
                    ),
                    const ProfileDivider(
                      height: 16,
                    ),
                    BlocSelector<UserCubit, UserState, LoadStatus?>(
                      selector: (state) {
                        return state.updateStatus;
                      },
                      builder: (context, updateStatus) {
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (updateStatus != LoadStatus.loading) {
                                userCubit.updateProfile(
                                  ProfileUpdateRequest(
                                    name: nameController.text,
                                    bio: bioController.text,
                                  ),
                                );
                              }
                            },
                            child: updateStatus == LoadStatus.loading
                                ? const LoadingCircle(
                                    size: 20,
                                    color: Colors.white,
                                  )
                                : Text(
                                    'Update Profile',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
}
