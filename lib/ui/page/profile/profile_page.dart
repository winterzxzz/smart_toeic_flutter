import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/ui/common/widgets/confirm_dia_log.dart';
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
    return BlocProvider(
      create: (context) => injector<UserCubit>(),
      child: const Page(),
    );
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

  @override
  void initState() {
    super.initState();
    final user = injector<UserCubit>().state.user;
    emailController = TextEditingController(text: user?.email ?? '');
    nameController = TextEditingController(text: user?.name ?? '');
    bioController = TextEditingController(text: user?.bio ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          emailController.text = state.user?.email ?? '';
          nameController.text = state.user?.name ?? '';
          bioController.text = state.user?.bio ?? '';
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                title: const Text('Profile'),
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
                              injector<UserCubit>().removeUser(context);
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
                              size: 14,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Logout',
                              style: theme.textTheme.bodyMedium,
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
                      AvatarHeading(user: state.user),
                      const ProfileDivider(
                        height: 16,
                      ),
                      TextFieldHeading(
                        controller: emailController,
                        label: 'Email',
                        hintText: 'Enter your email',
                        icon: FontAwesomeIcons.envelope,
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
                      TargetScoreWidget(
                        title: 'Reading Target / Reading Current',
                        targetScore: state.user?.targetScore?.reading,
                      ),
                      const SizedBox(height: 16),
                      TargetScoreWidget(
                        title: 'Listening Target / Listening Current',
                        targetScore: state.user?.targetScore?.listening,
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            showUpdateTargetDialog();
                          },
                          child: Text(
                            'Update Target Score',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
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
