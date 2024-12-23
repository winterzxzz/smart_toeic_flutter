import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toeic_desktop/common/global_blocs/setting/app_setting_cubit.dart';
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
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: AppStyle.edgeInsetsA12.copyWith(top: 0),
            child: Text(
              "Display Theme",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          BlocSelector<AppSettingCubit, AppSettingState, ThemeMode>(
            selector: (state) {
              return state.themeMode;
            },
            builder: (context, themeMode) {
              return SettingsCard(
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
                      groupValue: themeMode.index,
                      onChanged: (e) {
                        context.read<AppSettingCubit>().changeThemeMode(
                              themeMode: ThemeMode.values[e as int],
                            );
                      },
                    ),
                    RadioListTile<int>(
                      title: const Text(
                        "Light Mode",
                      ),
                      visualDensity: VisualDensity.compact,
                      value: 1,
                      contentPadding: AppStyle.edgeInsetsH12,
                      groupValue: themeMode.index,
                      onChanged: (e) {
                        context.read<AppSettingCubit>().changeThemeMode(
                              themeMode: ThemeMode.values[e as int],
                            );
                      },
                    ),
                    RadioListTile<int>(
                      title: const Text(
                        "Dark Mode",
                      ),
                      visualDensity: VisualDensity.compact,
                      value: 2,
                      contentPadding: AppStyle.edgeInsetsH12,
                      groupValue: themeMode.index,
                      onChanged: (e) {
                        context.read<AppSettingCubit>().changeThemeMode(
                              themeMode: ThemeMode.values[e as int],
                            );
                      },
                    ),
                  ],
                ),
              );
            },
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
