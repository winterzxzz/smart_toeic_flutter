import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/data/models/enums/bottom_tab_enum.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_images.dart';
import 'package:toeic_desktop/ui/page/bottom_tab/bottom_tab_cubit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomTabPage extends StatefulWidget {
  const BottomTabPage({super.key, required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  State<BottomTabPage> createState() => _BottomTabPageState();
}

class _BottomTabPageState extends State<BottomTabPage> {
  @override
  void initState() {
    super.initState();
    injector<BottomTabCubit>().updateNavigationShell(widget.navigationShell);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.1),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left - Logo
            InkWell(
              onTap: () {
                injector<BottomTabCubit>().updateIndex(0);
              },
              child: const Text(
                'Toeic',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            // Center - Navigation
            Row(
              mainAxisSize: MainAxisSize.min,
              children: BottomTabEnum.values
                  .map((item) => TextButton(
                        onPressed: () {
                          final index = item.index + 1;
                          injector<BottomTabCubit>().updateIndex(index);
                        },
                        child: Text(
                          item.title,
                          style: const TextStyle(
                            color: AppColors.textBlack,
                          ),
                        ),
                      ))
                  .toList(),
            ),

            // Right - Login Button
            BlocBuilder<UserCubit, UserState>(
              builder: (context, state) {
                if (state.user != null) {
                  return GestureDetector(
                    onTap: () {
                      // Show menu
                      showMenu(
                        context: context,
                        position: const RelativeRect.fromLTRB(32, 0, 0, 32),
                        items: [
                          PopupMenuItem(
                            child: Text('Logout'),
                            onTap: () {
                              injector<UserCubit>().removeUser();
                            },
                          ),
                        ],
                      );
                    },
                    child: SvgPicture.asset(
                      AppImages.icUserAvatarDefault,
                      width: 32,
                      height: 32,
                    ),
                  );
                }
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    final index = BottomTabEnum.values.length + 1;
                    injector<BottomTabCubit>().updateIndex(index);
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: AppColors.textWhite),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: widget.navigationShell,
    );
  }
}
