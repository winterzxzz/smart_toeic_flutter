import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/ui/common/widgets/confirm_dia_log.dart';
import 'package:toeic_desktop/ui/page/profile/profile_cubit.dart';
import 'package:toeic_desktop/ui/page/profile/widgets/avatar_heading.dart';
import 'package:toeic_desktop/ui/page/profile/widgets/profile_divider.dart';
import 'package:toeic_desktop/ui/page/profile/widgets/text_field_heading.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<ProfileCubit>(),
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
                backgroundColor: Colors.transparent,
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
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      AvatarHeading(user: state.user),
                      const ProfileDivider(),
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
                      const SizedBox(height: 16),
                      ...[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Reading Target / Reading Current',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        text:
                                            '${state.user?.targetScore?.reading ?? 0}',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                        children: [
                                          const TextSpan(
                                            text: '/450',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 16),
                                LinearProgressIndicator(
                                  backgroundColor: Colors.grey,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
                                  minHeight: 10,
                                  value: state.user?.targetScore?.reading !=
                                          null
                                      ? state.user!.targetScore!.reading / 450
                                      : 0,
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Expanded(
                                      child: Text(
                                        'Listening Target / Listening Current',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text.rich(
                                      TextSpan(
                                        text:
                                            '${state.user?.targetScore?.listening ?? 0}',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                        children: [
                                          const TextSpan(
                                            text: '/450',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w300),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 16),
                                LinearProgressIndicator(
                                  backgroundColor: Colors.grey,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
                                  minHeight: 10,
                                  value: state.user?.targetScore?.listening !=
                                          null
                                      ? state.user!.targetScore!.listening / 450
                                      : 0,
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  showUpdateTargetDialog(
                                    initialReadingScore:
                                        state.user?.targetScore?.reading,
                                    initialListeningScore:
                                        state.user?.targetScore?.listening,
                                  );
                                },
                                child: const Text('Update Target Score'),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 20),
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

  void showUpdateTargetDialog(
      {int? initialReadingScore, int? initialListeningScore}) {
    final readingController =
        TextEditingController(text: initialReadingScore?.toString() ?? '0');
    final listeningController =
        TextEditingController(text: initialListeningScore?.toString() ?? '0');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext diaglogContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Update Target Score',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(diaglogContext).pop();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text('Reading target score'),
              const SizedBox(height: 8),
              TextField(
                keyboardType: TextInputType.number,
                controller: readingController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  suffixIcon: Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_drop_up),
                        onPressed: () {
                          final currentValue =
                              int.tryParse(readingController.text) ?? 0;
                          if (currentValue < 450) {
                            readingController.text =
                                (currentValue + 5).toString();
                          }
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minHeight: 20),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_drop_down),
                        onPressed: () {
                          final currentValue =
                              int.tryParse(readingController.text) ?? 0;
                          if (currentValue > 0) {
                            readingController.text =
                                (currentValue - 5).toString();
                          }
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minHeight: 20),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Listening target score'),
              const SizedBox(height: 8),
              TextField(
                controller: listeningController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  suffixIcon: Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_drop_up),
                        onPressed: () {
                          final currentValue =
                              int.tryParse(listeningController.text) ?? 0;
                          if (currentValue < 450) {
                            listeningController.text =
                                (currentValue + 5).toString();
                          }
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minHeight: 20),
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_drop_down),
                        onPressed: () {
                          final currentValue =
                              int.tryParse(listeningController.text) ?? 0;
                          if (currentValue > 0) {
                            listeningController.text =
                                (currentValue - 5).toString();
                          }
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minHeight: 20),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    final readingScore =
                        int.tryParse(readingController.text) ?? 0;
                    final listeningScore =
                        int.tryParse(listeningController.text) ?? 0;

                    context
                        .read<ProfileCubit>()
                        .updateTargetScore(readingScore, listeningScore)
                        .then((_) {
                      if (diaglogContext.mounted) {
                        Navigator.of(diaglogContext).pop();
                      }
                    });
                  },
                  child: Text(
                    'Update'.toUpperCase(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
