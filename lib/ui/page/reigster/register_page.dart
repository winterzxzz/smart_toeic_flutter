import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/home/home_cubit.dart';
import 'package:toeic_desktop/ui/page/reigster/register_cubit.dart';
import 'package:toeic_desktop/ui/page/reigster/register_navigator.dart';
import 'package:toeic_desktop/ui/page/reigster/register_state.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<RegisterCubit>(),
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
  late TextEditingController emailController;
  late TextEditingController nameController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    nameController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _onLoginSuccess() {
    AppRouter.clearAndNavigate(AppRouter.home);
    injector<HomeCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    final navigator = RegisterNavigator(context: context);
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (LoadStatus.loading == state.loadDataStatus) {
          navigator.showLoadingOverlay();
        } else {
          navigator.hideLoadingOverlay();
        }
        if (LoadStatus.failure == state.loadDataStatus) {
          navigator.error(state.message);
        }
        if (LoadStatus.success == state.loadDataStatus) {
          showToast(
              title: 'Welcome to TOEIC Prep!',
              type: ToastificationType.success);
          _onLoginSuccess();
        }
      },
      child: Scaffold(
        body: Card(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome to TOEIC Prep',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Login to access our comprehensive TOEIC preparation resources',
                  style: TextStyle(color: AppColors.textGray),
                ),
                const SizedBox(height: 24),
                Form(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter your email',
                            labelStyle: TextStyle(color: AppColors.textGray),
                            hintStyle: TextStyle(
                              color: AppColors.textGray,
                              fontWeight: FontWeight.w400,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? AppColors.primary
                                    : AppColors.textWhite,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            hintText: 'Enter your name',
                            hintStyle: TextStyle(
                              color: AppColors.textGray,
                              fontWeight: FontWeight.w400,
                            ),
                            labelStyle: TextStyle(color: AppColors.textGray),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? AppColors.primary
                                    : AppColors.textWhite,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            hintStyle: TextStyle(
                              color: AppColors.textGray,
                              fontWeight: FontWeight.w400,
                            ),
                            labelStyle: TextStyle(color: AppColors.textGray),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).brightness ==
                                        Brightness.light
                                    ? AppColors.primary
                                    : AppColors.textWhite,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              context.read<RegisterCubit>().register(
                                    emailController.text,
                                    nameController.text,
                                    passwordController.text,
                                  );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Sign up',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Register
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                navigator.navigateToLogin();
                              },
                              child: const Text.rich(TextSpan(
                                text: 'Already have an account? ',
                                children: [
                                  TextSpan(
                                    text: 'Login',
                                    style: TextStyle(
                                      color: AppColors.textBlue,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppColors.textBlue,
                                    ),
                                  ),
                                ],
                              )),
                            ),
                            const Spacer(),
                            TextButton(
                                onPressed: () {
                                  navigator.navigateToResetPassword();
                                },
                                child: const Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    color: AppColors.textBlue,
                                    decoration: TextDecoration.underline,
                                    decorationColor: AppColors.textBlue,
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
