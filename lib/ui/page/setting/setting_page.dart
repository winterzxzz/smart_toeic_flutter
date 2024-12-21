import 'package:flutter/material.dart';
import 'package:toeic_desktop/ui/common/app_style.dart';
import 'package:toeic_desktop/ui/page/setting/widgets/setting_card.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appearance Settings"),
      ),
      body: ListView(
        padding: AppStyle.edgeInsetsA12,
        children: [
          Padding(
            padding: AppStyle.edgeInsetsA12.copyWith(top: 0),
            child: Text(
              "Display Theme",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          SettingsCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<int>(
                  title: const Text(
                    "Follow System",
                  ),
                  visualDensity: VisualDensity.compact,
                  value: 0,
                  contentPadding: AppStyle.edgeInsetsH12,
                  groupValue: 0,
                  onChanged: (e) {},
                ),
                RadioListTile<int>(
                  title: const Text(
                    "Light Mode",
                  ),
                  visualDensity: VisualDensity.compact,
                  value: 1,
                  contentPadding: AppStyle.edgeInsetsH12,
                  groupValue: 1,
                  onChanged: (e) {},
                ),
                RadioListTile<int>(
                  title: const Text(
                    "Dark Mode",
                  ),
                  visualDensity: VisualDensity.compact,
                  value: 2,
                  contentPadding: AppStyle.edgeInsetsH12,
                  groupValue: 2,
                  onChanged: (e) {},
                ),
              ],
            ),
          ),
          AppStyle.vGap12,
          Padding(
            padding: AppStyle.edgeInsetsA12,
            child: Text(
              "Theme Color",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ],
      ),
    );
  }
}
