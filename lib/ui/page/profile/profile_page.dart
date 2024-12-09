import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';
import 'package:toeic_desktop/ui/page/profile/widgets/avatar_heading.dart';
import 'package:toeic_desktop/ui/page/profile/widgets/custom_text_field.dart';
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(AppImages.profileBackground),
                fit: BoxFit.cover)),
        child: Stack(
          children: [
            _buildHeaderBody(),
            _buildBanner(),
            _buildImage(),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      height: 129,
    );
  }

  Container _buildImage() {
    return Container(
      margin: const EdgeInsets.only(top: (258.5 - 70) / 2 + 10),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: NetworkImage(
                      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'),
                  fit: BoxFit.cover),
            ),
          ),
          Row(
            children: [
              ElevatedButton(
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
              const SizedBox(width: 16),
              ElevatedButton(
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
              const SizedBox(width: 16),
              ElevatedButton(
                  onPressed: () {},
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FaIcon(FontAwesomeIcons.floppyDisk, size: 16),
                      const SizedBox(width: 8),
                      Text('Save'),
                    ],
                  )),
            ],
          )
        ],
      ),
    );
  }

  Container _buildHeaderBody() {
    return Container(
      height: double.infinity,
      margin: const EdgeInsets.only(top: 129),
      padding: const EdgeInsets.fromLTRB(20, 70, 20, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Theme.of(context).cardColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AvatarHeading(),
          const ProfileDivider(),
          TextFieldHeading(
            label: 'Profile Name',
            description: 'Your name will be displayed to other users',
            hintText: 'Enter your name',
            controller: TextEditingController(),
          ),
          const ProfileDivider(),
          TextFieldHeading(
            label: 'Profile Email',
            description: 'Your email will be displayed to other users',
            hintText: 'Enter your email',
            controller: TextEditingController(),
          ),
          const ProfileDivider(),
          HeadingContainer(
              title: 'Profile Tags',
              description: 'Add tags to your profile to help others find you',
              child: Column(
                children: [
                  CustomTextField(
                    icon: Icons.location_on,
                    tag: 'San Francisco, CA',
                    hintText: 'Enter your location',
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    icon: Icons.calendar_month,
                    tag: 'Joined September 2022',
                    hintText: 'Enter your join date',
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    icon: Icons.link,
                    tag: 'https://winter.com',
                    hintText: 'Enter your link',
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(onPressed: () {}, child: Text('Add Tag')),
                    ],
                  ),
                ],
              )),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class TagInfo extends StatelessWidget {
  const TagInfo({
    super.key,
    required this.title,
    required this.icon,
    this.isLink = false,
  });

  final String title;
  final IconData icon;
  final bool isLink;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: isLink ? Colors.blue : null,
          ),
        ),
      ],
    );
  }
}

class CustomRichText extends StatelessWidget {
  final String info;
  final String title;
  const CustomRichText({super.key, required this.info, required this.title});

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            text: '$info ',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
            children: [
          TextSpan(
            text: title,
            style: const TextStyle(
              fontWeight: FontWeight.w300,
            ),
          )
        ]));
  }
}
