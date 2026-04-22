import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/services/supabase_auth_service.dart';
import '../../data/services/biometric_service.dart';

class AuthProvider extends ChangeNotifier {
  final _service = SupabaseAuthService();
  final _biometricService = BiometricService();

  bool isLoading = false;
  String? error;
  List<Map<String, dynamic>> cars = [];
  Map<String, dynamic>? userProfile;

  AuthProvider() {
    _initialize();
  }

  Future<void> _initialize() async {
    if (isAuthenticated) {
      await fetchProfile();
    }
  }

  bool get isAuthenticated => _service.currentSession != null;
  String? get nationalId => _service.storedNationalId;
  String? get userEmail => _service.currentUserEmail;

  String get displayName {
    final name = userProfile?['name'] as String?;
    if (name != null && name.isNotEmpty) return name;

    // Fall back to the part of the email before the @ if the profile hasn't loaded yet
    return userEmail?.split('@').first ?? 'User';
  }

  Future<bool> signIn(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await _service.signIn(email, password);
      // Save credentials unconditionally so they are available if biometric is enabled later
      await _biometricService.saveCredentials(email, password);
      await fetchProfile();
      return true;
    } on AuthException catch (e) {
      error = e.message;
      return false;
    } catch (_) {
      error = 'An unexpected error occurred';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp(String email, String password) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final response = await _service.signUp(email, password);
      if (response.user == null) {
        error = 'Account already exists. Please check your email to confirm.';
        return false;
      }
      await _biometricService.saveCredentials(email, password);
      await fetchProfile();
      return true;
    } on AuthException catch (e) {
      error = e.message;
      return false;
    } catch (_) {
      error = 'An unexpected error occurred';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    isLoading = true;
    notifyListeners();
    try {
      await _service.signOut();
      if (!(await _biometricService.isBiometricEnabled())) {
        await _biometricService.clearCredentials();
      }
      cars = [];
      userProfile = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveProfile({
    required String nationalId,
    required String name,
    required String phone,
    required String dob,
    required String gender,
  }) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await _service.saveProfile(
        nationalId: nationalId,
        name: name,
        phone: phone,
        dob: dob,
        gender: gender,
      );
      userProfile = {
        'national_id': nationalId,
        'name': name,
        'phone_number': phone,
        'date_of_birth': dob,
        'gender': gender,
      };
      return true;
    } on PostgrestException catch (e) {
      error = e.message;
      return false;
    } catch (_) {
      error = 'Failed to save profile';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProfile() async {
    final id = nationalId;
    if (id == null) return;
    isLoading = true;
    notifyListeners();
    try {
      userProfile = await _service.fetchProfile(id);
    } catch (_) {
      error = 'Failed to load profile';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
    required String name,
    required String phone,
    required String dob,
    required String gender,
  }) async {
    final id = nationalId;
    if (id == null) return false;
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await _service.updateProfile(
        nationalId: id,
        name: name,
        phone: phone,
        dob: dob,
        gender: gender,
      );
      userProfile = {
        ...?userProfile,
        'name': name,
        'phone_number': phone,
        'date_of_birth': dob,
        'gender': gender,
      };
      return true;
    } on PostgrestException catch (e) {
      error = e.message;
      return false;
    } catch (_) {
      error = 'Failed to update profile';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCars() async {
    final id = nationalId;
    if (id == null) return;
    isLoading = true;
    notifyListeners();
    try {
      cars = await _service.fetchCars(id);
    } catch (_) {
      error = 'Failed to load vehicles';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addCar(Map<String, dynamic> data) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await _service.insertCar(data);
      await fetchCars();
      return true;
    } on PostgrestException catch (e) {
      error = e.message;
      return false;
    } catch (_) {
      error = 'Failed to save vehicle';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> deleteCar(String carRegistrationId) async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      await _service.deleteCar(carRegistrationId);
      cars.removeWhere((c) => c['car_registration_id'] == carRegistrationId);
      return true;
    } on PostgrestException catch (e) {
      error = e.message;
      return false;
    } catch (_) {
      error = 'Failed to delete vehicle';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
