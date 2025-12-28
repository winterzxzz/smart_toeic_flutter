import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:toeic_desktop/common/utils/biometric_helper.dart';
import 'package:toeic_desktop/data/database/secure_storage_helper.dart';
import 'package:toeic_desktop/ui/common/app_colors.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';

mixin BiometricSetupMixin<T extends StatefulWidget> on State<T> {
  Future<void> showBiometricSetupDialog({
    required VoidCallback onComplete,
  }) async {
    final canUseBiometric = await BiometricHelper.instance.canCheckBiometrics();
    final isDeviceSupported =
        await BiometricHelper.instance.isDeviceSupported();

    if (!canUseBiometric || !isDeviceSupported) {
      if (mounted) {
        onComplete();
      }
      return;
    }

    if (!mounted) return;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Đăng nhập sinh trắc học'),
        content: const Text(
          'Bạn có muốn bật đăng nhập bằng vân tay/Face ID cho lần sau không?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Không',
              style: context.textTheme.titleSmall
                  ?.copyWith(color: AppColors.textGray),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Bật',
              style: context.textTheme.titleSmall
                  ?.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      await SecureStorageHelper.instance.setBiometricEnabled(true);
      showToast(
        title: 'Đã bật đăng nhập sinh trắc học',
        type: ToastificationType.success,
      );
    }

    if (mounted) {
      onComplete();
    }
  }
}
