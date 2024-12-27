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
                fit: BoxFit.cover)),
        child: Stack(
          children: [
            BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                emailController.text = state.user?.email ?? '';
                nameController.text = state.user?.name ?? '';
                bioController.text = state.user?.bio ?? '';
                return Container(
                  height: double.infinity,
                  margin: const EdgeInsets.only(top: 75),
                  padding: const EdgeInsets.fromLTRB(0, 70, 0, 0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Theme.of(context).cardColor),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      const SizedBox(height: 32),
                      AvatarHeading(
                        user: state.user,
                      ),
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
                                        Text('Reading Target / Reading Current',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            )),
                                        Text.rich(
                                          TextSpan(
                                            text:
                                                '${state.user?.targetScore?.reading ?? 0}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: '/450',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w300,
                                                ),
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
                                const SizedBox(height: 32),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            'Listening Target / Listening Current',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            )),
                                        Text.rich(
                                          TextSpan(
                                            text:
                                                '${state.user?.targetScore?.listening ?? 0}',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: '/450',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w300,
                                                ),
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
                                const SizedBox(height: 32),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                      onPressed: () {
                                        showUpdateTargetDialog(
                                          initialReadingScore:
                                              state.user?.targetScore?.reading,
                                          initialListeningScore: state
                                              .user?.targetScore?.listening,
                                        );
                                      },
                                      child: Text('Update Target Score')),
                                ),
                              ],
                            ))],
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
            _buildImage(),
          ],
        ),
      ),
    );
  }

  Container _buildImage() {
    return Container(
      margin: const EdgeInsets.only(top: (158.5 - 70) / 2 + 50),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: () {},
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.clockRotateLeft, size: 16),
                  const SizedBox(width: 8),
                  Text('See history test'),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                GoRouter.of(context).pushNamed(AppRouter.analysis);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.chartLine, size: 16),
                  const SizedBox(width: 8),
                  Text('Analyze Result'),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            height: 40,
            child: ElevatedButton(
                onPressed: () {
                  context.read<ProfileCubit>().updateProfile(
                      ProfileUpdateRequest(
                          name: nameController.text, bio: bioController.text));
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    FaIcon(FontAwesomeIcons.floppyDisk, size: 16),
                    const SizedBox(width: 8),
                    Text('Save'),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  void showUpdateTargetDialog(
      {int? initialReadingScore, int? initialListeningScore}) {
    final readingController =
        TextEditingController(text: initialReadingScore?.toString() ?? '0');
    final listeningController =
        TextEditingController(text: initialListeningScore?.toString() ?? '0');
    showDialog(
      context: context,
      builder: (BuildContext diaglogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            padding: const EdgeInsets.all(24),
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cập nhật điểm mục tiêu',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        GoRouter.of(diaglogContext).pop();
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
                              // Max TOEIC score for listening
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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: listeningController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            suffixIcon: Column(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_drop_up),
                                  onPressed: () {
                                    final currentValue = int.tryParse(
                                            listeningController.text) ??
                                        0;
                                    if (currentValue < 450) {
                                      // Max TOEIC score for listening
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
                                    final currentValue = int.tryParse(
                                            listeningController.text) ??
                                        0;
                                    if (currentValue > 0) {
                                      listeningController.text =
                                          (currentValue - 5).toString();
                                    }
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: BoxConstraints(minHeight: 20),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
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
                      // Handle save changes with values from controllers
                      final readingScore =
                          int.tryParse(readingController.text) ?? 0;
                      final listeningScore =
                          int.tryParse(listeningController.text) ?? 0;

                      context
                          .read<ProfileCubit>()
                          .updateTargetScore(readingScore, listeningScore)
                          .then((_) {
                        if (diaglogContext.mounted) {
                          GoRouter.of(diaglogContext).pop();
                        }
                      });
                      // Do something with the scores
                    },
                    child: Text(
                      'Update'.toUpperCase(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
