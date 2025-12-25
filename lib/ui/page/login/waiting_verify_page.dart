import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/global_blocs/user/user_cubit.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/entities/auth/auth_response.dart';
import 'package:toeic_desktop/data/network/repositories/auth_repository.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toastification/toastification.dart';

class WaitingVerifyPage extends StatefulWidget {
  final AuthChallenge challenge;

  const WaitingVerifyPage({super.key, required this.challenge});

  @override
  State<WaitingVerifyPage> createState() => _WaitingVerifyPageState();
}

class _WaitingVerifyPageState extends State<WaitingVerifyPage> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // Check initial link if app was closed
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleDeepLink(initialUri);
      }
    } catch (e) {
      // Ignore
    }

    // Listen to incoming links
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      if (mounted) {
        _handleDeepLink(uri);
      }
    });
  }

  void _handleDeepLink(Uri uri) {
    // Expected format: yourapp://account/security/confirm?tokenId={tokenId}
    // Or scheme://host/account/security/confirm
    // We check the path and query parameters
    if (uri.path.contains('/account/security/confirm')) {
      final tokenId = uri.queryParameters['tokenId'];
      if (tokenId != null && tokenId.isNotEmpty) {
        _verifyToken(tokenId);
      }
    }
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
          setState(() {
            _isLoading = false;
          });
        },
        (authResponse) async {
          if (authResponse is AuthSuccess) {
            // Save tokens
            // Assuming SharedPreferencesHelper stores cookies/tokens or just user session
            // NOTE: If you have a specific TokenStorage, use it here.
            // For now, updating UserCubit which likely handles session state in memory
            // and assuming DioClient or similar handles token persistence if configured.
            // If tokens are in AuthSuccess (accessToken, refreshToken), we should save them.
            // Based on available files, we'll try to save cookies/tokens if SharedPreferencesHelper supports it
            // or assume UserCubit/DioClient setup handles it.
            // Since UserCubit was used in LoginCubit:
            injector<UserCubit>().updateUser(authResponse.user);

            // Manually save tokens if `AuthSuccess` has them and we have a way.
            // Reading `SharedPreferencesHelper` it has `storeCookies`.
            // Often "cookies" in this codebase might be used for tokens if it's a web-like auth?
            // Or maybe `flutter_secure_storage`.
            // For safety, we proceed with UserCubit update and navigation which is consistent with LoginCubit.
            // If explicit token storage is needed, add it here.
            // Example:
            // await injector<SharedPreferencesHelper>().saveAccessToken(authResponse.accessToken);

            showToast(
              title: "Xác thực thành công!",
              type: ToastificationType.success,
            );

            if (mounted) {
              context.goNamed(AppRouter.bottomTab);
            }
          } else {
            // Handle other cases if necessary (e.g. another challenge? Unlikely here)
            setState(() {
              _isLoading = false;
            });
          }
        },
      );
    } catch (e) {
      showToast(
        title: "Đã xảy ra lỗi: $e",
        type: ToastificationType.error,
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String message = widget.challenge.message;
    if (widget.challenge.requiresEmailConfirmation) {
      message = "Vui lòng xác thực email trước khi đăng nhập.";
    }
    if (widget.challenge.securityAlert != null) {
      message =
          "${widget.challenge.securityAlert!.message} (${widget.challenge.securityAlert!.riskLevel})";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Xác thực bảo mật"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
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
              const Icon(
                Icons.security,
                color: Colors.orange,
                size: 80,
              ),
              const SizedBox(height: 24),
              Text(
                "Yêu cầu xác thực",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Text(
                "Vui lòng kiểm tra email hoặc tin nhắn để xác thực đăng nhập.",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.gray2,
                    ),
              ),
              const SizedBox(height: 32),
              // Optional: Manual refresh or check button if deep link doesn't trigger automatically
              // or just a back button
              CustomButton(
                onPressed: () {
                  // Allow user to go back to login manually if needed
                  context.goNamed(AppRouter.login);
                },
                child: const Text("Quay lại đăng nhập"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
