import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/request/profile_update_request.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';
import 'package:toeic_desktop/ui/page/profile/profile_cubit.dart';
import 'package:toeic_desktop/ui/page/profile/widgets/avatar_heading.dart';
import 'package:toeic_desktop/ui/page/profile/widgets/heading_container.dart';
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
      child: Page(),
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImages.profileBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            emailController.text = state.user?.email ?? '';
            nameController.text = state.user?.name ?? '';
            bioController.text = state.user?.bio ?? '';
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child:
                      SizedBox(height: MediaQuery.of(context).padding.top + 16),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Theme.of(context).cardColor,
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                    child: Column(
                      children: [
                        _buildImage(),
                        const SizedBox(height: 24),
                        AvatarHeading(user: state.user),
                        const ProfileDivider(),
                        TextFieldHeading(
                          label: 'Profile Email',
                          description:
                              'Your email will be displayed to other users and cannot be changed',
                          hintText: 'Enter your email',
                          controller: emailController,
                        ),
                        const ProfileDivider(),
                        TextFieldHeading(
                          label: 'Profile Name',
                          description:
                              'Your name will be displayed to other users',
                          hintText: 'Enter your name',
                          controller: nameController,
                        ),
                        const ProfileDivider(),
                        TextFieldHeading(
                          label: 'Profile Bio',
                          description:
                              'Your bio will be displayed to other users',
                          hintText: 'Enter your bio',
                          controller: bioController,
                        ),
                        ...[
                          const ProfileDivider(),
                          HeadingContainer(
                            title: 'Profile Target Score',
                            description:
                                'Your target score will be used to calculate your progress',
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
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
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                            children: [
                                              TextSpan(
                                                text: '/450',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w300),
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
                                          ? state.user!.targetScore!.reading /
                                              450
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
                                        Expanded(
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
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                            children: [
                                              TextSpan(
                                                text: '/450',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w300),
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
                                      value: state.user?.targetScore
                                                  ?.listening !=
                                              null
                                          ? state.user!.targetScore!.listening /
                                              450
                                          : 0,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: double.infinity,
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      showUpdateTargetDialog(
                                        initialReadingScore:
                                            state.user?.targetScore?.reading,
                                        initialListeningScore:
                                            state.user?.targetScore?.listening,
                                      );
                                    },
                                    child: Text('Update Target Score'),
                                  ),
                                ),
                              ],
                            ),
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
      ),
    );
  }

  Widget _buildImage() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    GoRouter.of(context).pushNamed(AppRouter.historyTest);
                  },
                  icon: FaIcon(FontAwesomeIcons.clockRotateLeft, size: 16),
                  label: Text('History'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    GoRouter.of(context).pushNamed(AppRouter.analysis);
                  },
                  icon: FaIcon(FontAwesomeIcons.chartLine, size: 16),
                  label: Text('Analysis'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              context.read<ProfileCubit>().updateProfile(ProfileUpdateRequest(
                  name: nameController.text, bio: bioController.text));
            },
            icon: FaIcon(FontAwesomeIcons.floppyDisk, size: 16),
            label: Text('Save Changes'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
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
      shape: RoundedRectangleBorder(
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
                  Text(
                    'Update Target Score',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(diaglogContext).pop();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text('Reading target score'),
              const SizedBox(height: 8),
              TextField(
                keyboardType: TextInputType.number,
                controller: readingController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_drop_up),
                        onPressed: () {
                          final currentValue =
                              int.tryParse(readingController.text) ?? 0;
                          if (currentValue < 450) {
                            readingController.text =
                                (currentValue + 5).toString();
                          }
                        },
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(minHeight: 20),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_drop_down),
                        onPressed: () {
                          final currentValue =
                              int.tryParse(readingController.text) ?? 0;
                          if (currentValue > 0) {
                            readingController.text =
                                (currentValue - 5).toString();
                          }
                        },
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(minHeight: 20),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('Listening target score'),
              const SizedBox(height: 8),
              TextField(
                controller: listeningController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_drop_up),
                        onPressed: () {
                          final currentValue =
                              int.tryParse(listeningController.text) ?? 0;
                          if (currentValue < 450) {
                            listeningController.text =
                                (currentValue + 5).toString();
                          }
                        },
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(minHeight: 20),
                      ),
                      IconButton(
                        icon: Icon(Icons.arrow_drop_down),
                        onPressed: () {
                          final currentValue =
                              int.tryParse(listeningController.text) ?? 0;
                          if (currentValue > 0) {
                            listeningController.text =
                                (currentValue - 5).toString();
                          }
                        },
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(minHeight: 20),
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
