import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BiometricService {
  static const _biometricKey = 'biometric_enabled';
  static const _emailKey = 'biometric_email';
  static const _passwordKey = 'biometric_password';

  final _auth = LocalAuthentication();

  Future<bool> isAvailable() async {
    final canCheck = await _auth.canCheckBiometrics;
    final isSupported = await _auth.isDeviceSupported();
    return canCheck && isSupported;
  }

  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Use biometric to access Janneb',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  Future<bool> isBiometricEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_biometricKey) ?? false;
  }

  Future<void> setBiometricEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_biometricKey, value);
  }

  Future<void> saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    await prefs.setString(_passwordKey, password);
  }

  Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_emailKey);
    await prefs.remove(_passwordKey);
  }

  Future<Map<String, String>?> getCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString(_emailKey);
    final password = prefs.getString(_passwordKey);

    if (email != null && password != null) {
      return {'email': email, 'password': password};
    }
    return null;
  }
}
