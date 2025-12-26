import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toeic_desktop/app.dart';
import 'package:toeic_desktop/common/router/route_config.dart';
import 'package:toeic_desktop/data/models/enums/load_status.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/widgets/custom_button.dart';
import 'package:toeic_desktop/ui/page/login/waiting_verify_cubit.dart';
import 'package:toeic_desktop/ui/page/login/waiting_verify_state.dart';

class WaitingVerifyPage extends StatelessWidget {
  const WaitingVerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<WaitingVerifyCubit>()..startPolling(),
      child: const _Page(),
    );
  }
}

class _Page extends StatefulWidget {
  const _Page();

  @override
  State<_Page> createState() => _PageState();
}

class _PageState extends State<_Page> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<WaitingVerifyCubit, WaitingVerifyState>(
      listener: (context, state) {
        if (state.loadStatus == LoadStatus.success) {
          context.goNamed(AppRouter.bottomTab);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Xác thực đăng nhập"),
          centerTitle: true,
          automaticallyImplyLeading: false, // Prevent back navigation
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 24),
                Text(
                  "Đang chờ xác thực...",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Vui lòng xác thực tài khoản của bạn. Màn hình sẽ tự động chuyển khi hoàn tất.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textGray,
                      ),
                ),
                const SizedBox(height: 32),
                CustomButton(
                  onPressed: () {
                    context.goNamed(AppRouter.login);
                  },
                  backgroundColor: Colors.grey,
                  child: const Text("Quay lại đăng nhập"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
