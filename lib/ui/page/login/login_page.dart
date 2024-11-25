import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/page/bottom_tab/bottom_tab_cubit.dart';
import 'package:toeic_desktop/ui/page/login/login_cubit.dart';
import 'package:toeic_desktop/ui/page/login/login_navigator.dart';
import 'package:toeic_desktop/ui/page/login/login_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<LoginCubit>(),
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
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _navigator = LoginNavigator(context: context);
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (LoadStatus.loading == state.loadStatus) {
          _navigator.showLoadingOverlay();
        } else {
          _navigator.hideLoadingOverlay();
        }
        if (LoadStatus.failure == state.loadStatus) {
          _navigator.error(state.errorMessage);
        }
        if (LoadStatus.success == state.loadStatus) {
          _navigator.success("Welcome back!");
          injector<BottomTabCubit>().updateIndex(0);
        }
      },
      child: Scaffold(
        body: SizedBox(
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
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(
                            color: AppColors.textGray,
                            fontWeight: FontWeight.w400,
                          ),
                          labelStyle: TextStyle(color: AppColors.textGray),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.gray1, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(
                            color: AppColors.textGray,
                            fontWeight: FontWeight.w400,
                          ),
                          labelStyle: TextStyle(color: AppColors.textGray),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.gray1, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primary,
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
                            context.read<LoginCubit>().login(
                                  emailController.text,
                                  passwordController.text,
                                );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Login',
                            style: TextStyle(color: AppColors.textWhite),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // or continue with
                      const Row(
                        children: [
                          Expanded(child: Divider()),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'Or continue with',
                              style: TextStyle(
                                color: AppColors.textGray,
                              ),
                            ),
                          ),
                          Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Row of social login
                      const SocialButtons(),
                      const SizedBox(height: 16),
                      // Register
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _navigator.navigateToRegister();
                            },
                            child: const Text.rich(TextSpan(
                              text: 'Don\'t have an account? ',
                              children: [
                                TextSpan(
                                  text: 'Register',
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
                                _navigator.navigateToResetPassword();
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
    );
  }
}

class SocialButtons extends StatelessWidget {
  const SocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: SizedBox(
            height: 45,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.facebook,
                    color: AppColors.textWhite,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Facebook',
                    style: TextStyle(color: AppColors.textWhite),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SizedBox(
            height: 45,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.google,
                    color: AppColors.textWhite,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Google',
                    style: TextStyle(color: AppColors.textWhite),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
