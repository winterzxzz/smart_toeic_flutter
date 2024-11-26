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
      body: Row(
        children: [
          Container(
            width: 256,
            decoration: BoxDecoration(
              color: AppColors.primary,
            ),
            child: Column(
              children: [
                // Left - Logo
                InkWell(
                  onTap: () {
                    injector<BottomTabCubit>().updateIndex(0);
                  },
                  child: const Text(
                    'Toeic',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textWhite,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Center - Navigation
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: BottomTabEnum.values
                      .map((item) => InkWell(
                            onTap: () {
                              final index = item.index + 1;
                              injector<BottomTabCubit>().updateIndex(index);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              margin: const EdgeInsets.only(bottom: 8, left: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                                color: widget.navigationShell.currentIndex ==
                                        item.index + 1
                                    ? Theme.of(context).scaffoldBackgroundColor
                                    : Colors.transparent,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    item.icon,
                                    color:
                                        widget.navigationShell.currentIndex ==
                                                item.index + 1
                                            ? AppColors.textBlack
                                            : AppColors.textWhite,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    item.title,
                                    style: TextStyle(
                                      color:
                                          widget.navigationShell.currentIndex ==
                                                  item.index + 1
                                              ? AppColors.textBlack
                                              : AppColors.textWhite,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),

                const Spacer(),

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
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          injector<BottomTabCubit>()
                              .updateIndex(BottomTabEnum.values.length + 1);
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(color: AppColors.textBlack),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          Expanded(child: widget.navigationShell),
        ],
      ),
    );
  }
}
