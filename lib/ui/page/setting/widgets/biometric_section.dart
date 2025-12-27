import 'package:flutter/material.dart';
import 'package:toeic_desktop/common/utils/biometric_helper.dart';
import 'package:toeic_desktop/data/database/secure_storage_helper.dart';
import 'package:toeic_desktop/ui/common/app_context.dart';
import 'package:toeic_desktop/ui/common/app_style.dart';
import 'package:toeic_desktop/ui/common/widgets/show_toast.dart';
import 'package:toeic_desktop/ui/page/setting/widgets/setting_card.dart';
import 'package:toeic_desktop/ui/page/setting/widgets/settting_switch.dart';
import 'package:toastification/toastification.dart';

class BiometricSection extends StatefulWidget {
  const BiometricSection({super.key});

  @override
  State<BiometricSection> createState() => _BiometricSectionState();
}

class _BiometricSectionState extends State<BiometricSection> {
  bool _isEnabled = false;
  bool _isSupported = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBiometricStatus();
  }

  Future<void> _loadBiometricStatus() async {
    final isEnabled = await SecureStorageHelper.instance.getBiometricEnabled();
    final canCheck = await BiometricHelper.instance.canCheckBiometrics();
    final isSupported = await BiometricHelper.instance.isDeviceSupported();

    if (mounted) {
      setState(() {
        _isEnabled = isEnabled;
        _isSupported = canCheck && isSupported;
        _isLoading = false;
      });
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    try {
      // Require biometric verification for both enabling and disabling
      final result = await BiometricHelper.instance.authenticate(
        localizedReason: value
            ? 'Xác thực để bật đăng nhập sinh trắc học'
            : 'Xác thực để tắt đăng nhập sinh trắc học',
      );

      debugPrint('[BiometricSection] authenticate result: $result');

      if (result == BiometricResult.success) {
        await SecureStorageHelper.instance.setBiometricEnabled(value);
        setState(() {
          _isEnabled = value;
        });
        showToast(
          title: value
              ? 'Đã bật đăng nhập sinh trắc học'
              : 'Đã tắt đăng nhập sinh trắc học',
          type: value ? ToastificationType.success : ToastificationType.info,
        );
      } else {
        debugPrint(
            '[BiometricSection] authenticate failed with result: $result');
        showToast(
          title: 'Xác thực thất bại',
          type: ToastificationType.error,
        );
      }
    } catch (e, stackTrace) {
      debugPrint('[BiometricSection] Error in _toggleBiometric: $e');
      debugPrint('[BiometricSection] StackTrace: $stackTrace');
      showToast(
        title: 'Đã xảy ra lỗi: $e',
        type: ToastificationType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const SizedBox.shrink();
    }

    if (!_isSupported) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: AppStyle.edgeInsetsA12,
            child: Text(
              "Security",
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color:
                    context.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              ),
            ),
          ),
          SettingsCard(
            child: SettingsSwitch(
              title: 'Biometric login',
              subtitle: 'Use fingerprint or Face ID to login',
              value: _isEnabled,
              onChanged: _toggleBiometric,
            ),
          ),
        ],
      ),
    );
  }
}
