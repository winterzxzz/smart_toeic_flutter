import 'package:flutter/material.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/setting/app_setting_cubit.dart';
import 'package:toeic_desktop/language/generated/l10n.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/widgets/leading_back_button.dart';
import 'package:toeic_desktop/ui/page/setting/widgets/color_section.dart';
import 'package:toeic_desktop/ui/page/setting/widgets/language_section.dart';
import 'package:toeic_desktop/ui/page/setting/widgets/reminder_section.dart';
import 'package:toeic_desktop/ui/page/setting/widgets/theme_section.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late final AppSettingCubit appSettingCubit;

  @override
  void initState() {
    super.initState();
    appSettingCubit = injector<AppSettingCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          S.current.settings,
          style: textTheme.titleMedium,
        ),
        leading: const LeadingBackButton(),
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ThemeSection(),
            SizedBox(height: 16),
            LanguageSection(),
            SizedBox(height: 16),
            ColorSection(),
            SizedBox(height: 16),
            ReminderSection(),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
