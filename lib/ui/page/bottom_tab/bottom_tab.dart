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

class _BottomTabPageState extends State<BottomTabPage>
    with TickerProviderStateMixin {
  bool _isChatVisible = false;
  late AnimationController _animationController;
  final List<String> _messages = [
    "Hi! 👋 I'm Finch, and I'll be your guide to Sendbird today.",
    "Did you know in-app messages boost engagement rates by 131%?",
    "Tell me which of the following interests you in enhancing customer communication :)"
  ];

  @override
  void initState() {
    super.initState();
    injector<BottomTabCubit>().updateNavigationShell(widget.navigationShell);
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.primary,
        ),
        child: IconButton(
          onPressed: () {
            setState(() {
              _isChatVisible = !_isChatVisible;
              if (_isChatVisible) {
                _animationController.forward();
              } else {
                _animationController.reverse();
              }
            });
          },
          icon: _isChatVisible
              ? Icon(
                  Icons.close,
                  color: AppColors.textWhite,
                )
              : Icon(
                  Icons.message,
                  color: AppColors.textWhite,
                ),
        ),
      ),
      body: Stack(
        children: [
          Row(
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
                                  margin:
                                      const EdgeInsets.only(bottom: 8, left: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomLeft: Radius.circular(8),
                                    ),
                                    color:
                                        widget.navigationShell.currentIndex ==
                                                item.index + 1
                                            ? Theme.of(context)
                                                .scaffoldBackgroundColor
                                            : Colors.transparent,
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        item.icon,
                                        color: widget.navigationShell
                                                    .currentIndex ==
                                                item.index + 1
                                            ? AppColors.textBlack
                                            : AppColors.textWhite,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        item.title,
                                        style: TextStyle(
                                          color: widget.navigationShell
                                                      .currentIndex ==
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
                                position: RelativeRect.fromSize(
                                  Rect.fromPoints(
                                    Offset(
                                      0,
                                      MediaQuery.of(context).size.height,
                                    ),
                                    Offset(300,
                                        MediaQuery.of(context).size.height),
                                  ),
                                  Size(500, 100),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                color: AppColors.textWhite,
                                items: [
                                  PopupMenuItem(
                                    child: Row(
                                      children: [
                                        Icon(Icons.person),
                                        const SizedBox(width: 8),
                                        Text('Profile'),
                                      ],
                                    ),
                                    onTap: () {},
                                  ),
                                  PopupMenuItem(
                                    child: Row(
                                      children: [
                                        Icon(Icons.settings),
                                        const SizedBox(width: 8),
                                        Text('Setting'),
                                      ],
                                    ),
                                    onTap: () {},
                                  ),
                                  PopupMenuItem(
                                    child: Row(
                                      children: [
                                        Icon(Icons.logout),
                                        const SizedBox(width: 8),
                                        Text('Logout'),
                                      ],
                                    ),
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Logout'),
                                          content: Text('Are you sure?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                injector<UserCubit>()
                                                    .removeUser();
                                              },
                                              child: Text('Logout'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    AppImages.icUserAvatarDefault,
                                    width: 32,
                                    height: 32,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    state.user?.email ?? '',
                                    style: TextStyle(
                                      color: AppColors.textWhite,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
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
          AnimatedPositioned(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _isChatVisible ? 70 : -416,
            left: _isChatVisible
                ? MediaQuery.of(context).size.width - 416
                : MediaQuery.of(context).size.width,
            width: 400,
            child: ScaleTransition(
              scale: _isChatVisible
                  ? Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.easeInOut,
                      ),
                    )
                  : AlwaysStoppedAnimation(0.0),
              child: Container(
                height: 500,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Finch from Sendbird",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              _isChatVisible = false;
                            });
                          },
                        ),
                      ],
                    ),
                    Divider(),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(_messages[index]),
                          );
                        },
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Enter message",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.send),
                      ),
                      onSubmitted: (text) {
                        setState(() {
                          _messages.add(text);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
