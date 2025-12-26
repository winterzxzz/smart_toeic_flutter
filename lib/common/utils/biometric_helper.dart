import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricHelper {
  static final BiometricHelper _instance = BiometricHelper._();
  static BiometricHelper get instance => _instance;

  final LocalAuthentication _auth = LocalAuthentication();

  BiometricHelper._();

  /// Check if the device supports biometric authentication
  Future<bool> isDeviceSupported() async {
    return await _auth.isDeviceSupported();
  }

  /// Check if biometrics are available (enrolled)
  Future<bool> canCheckBiometrics() async {
    try {
      return await _auth.canCheckBiometrics;
    } on PlatformException {
      return false;
    }
  }

  /// Get the list of available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException {
      return [];
    }
  }

  /// Authenticate with biometrics
  /// Returns true if authentication succeeded, false otherwise
  Future<BiometricResult> authenticate({
    String localizedReason = 'Xác thực để đăng nhập',
  }) async {
    try {
      final bool didAuthenticate = await _auth.authenticate(
        localizedReason: localizedReason,
      );
      return didAuthenticate ? BiometricResult.success : BiometricResult.failed;
    } on PlatformException catch (e) {
      if (e.code == 'NotAvailable') {
        return BiometricResult.notAvailable;
      } else if (e.code == 'NotEnrolled') {
        return BiometricResult.notEnrolled;
      } else if (e.code == 'LockedOut' || e.code == 'PermanentlyLockedOut') {
        return BiometricResult.lockedOut;
      }
      return BiometricResult.error;
    } catch (e) {
      // Catch any other error (e.g., desktop not supported)
      return BiometricResult.error;
    }
  }

  /// Cancel any ongoing authentication
  Future<bool> cancelAuthentication() async {
    return await _auth.stopAuthentication();
  }
}

enum BiometricResult {
  success,
  failed,
  notAvailable,
  notEnrolled,
  lockedOut,
  error,
}
