import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/entities/auth/auth_response.dart';
import 'package:toeic_desktop/data/network/repositories/auth_repository.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toastification/toastification.dart';

class VerifyLoginPage extends StatefulWidget {
  final String tokenId;

  const VerifyLoginPage({super.key, required this.tokenId});

  @override
  State<VerifyLoginPage> createState() => _VerifyLoginPageState();
}

class _VerifyLoginPageState extends State<VerifyLoginPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Delay slightly to ensure UI is built, or just call immediately
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _verifyToken(widget.tokenId);
    });
  }

  Future<void> _verifyToken(String tokenId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await injector<AuthRepository>().confirmLogin(tokenId);

      result.fold(
        (failure) {
          showToast(
            title: "Xác thực thất bại: ${failure.message}",
            type: ToastificationType.error,
          );
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
            // Optionally go back to login or show error state
            context.goNamed(AppRouter.login);
          }
        },
        (authResponse) async {
          if (authResponse is AuthSuccess) {
            injector<UserCubit>().updateUser(authResponse.user);

            showToast(
              title: "Xác thực thành công!",
              type: ToastificationType.success,
            );

            if (mounted) {
              context.goNamed(AppRouter.bottomTab);
            }
          } else {
            showToast(
              title: "Xác thực không thành công. Vui lòng thử lại.",
              type: ToastificationType.warning,
            );
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
              context.goNamed(AppRouter.login);
            }
          }
        },
      );
    } catch (e) {
      showToast(
        title: "Đã xảy ra lỗi: $e",
        type: ToastificationType.error,
      );
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        context.goNamed(AppRouter.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Xác thực đăng nhập"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (_isLoading) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                "Đang xác thực...",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ] else ...[
              // Fallback UI if not loading and didn't navigate (e.g. error but stayed on page)
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 80,
              ),
              const SizedBox(height: 24),
              Text(
                "Xác thực thất bại",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                onPressed: () {
                  context.goNamed(AppRouter.login);
                },
                child: const Text("Quay lại đăng nhập"),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
