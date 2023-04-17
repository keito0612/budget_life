import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:local_auth/local_auth.dart';

final localAuthenticationProvider = Provider<LocalAuthentication>(
  (ref) => LocalAuthentication(),
);

final authControllerProvider = Provider<AuthControllerProvider>(
  (ref) => AuthControllerProvider(ref),
);

class AuthControllerProvider {
  AuthControllerProvider(this._ref);
  final Ref _ref;

  LocalAuthentication get _auth => _ref.read(localAuthenticationProvider);

  Future<bool> get canCheckBiometrics => _auth.canCheckBiometrics;

  Future<bool> didAuthenticate() async {
    final availableBiometrics = await _getAvailableBiometricTypes();
    var result = false;
    try {
      if (availableBiometrics.contains(BiometricType.face) ||
          availableBiometrics.contains(BiometricType.fingerprint)) {
        result = await _auth.authenticate(
          localizedReason: '認証を実行してください。',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true,
            biometricOnly: true,
          ),
        );
      }
    } on PlatformException catch (e) {
      print(e);
    }
    return result;
  }

  Future<List<BiometricType>> _getAvailableBiometricTypes() async {
    late List<BiometricType> availableBiometricTypes;
    try {
      availableBiometricTypes = await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    return availableBiometricTypes;
  }
}
