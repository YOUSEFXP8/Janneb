import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseAuthService {
  final _client = Supabase.instance.client;

  Session? get currentSession => _client.auth.currentSession;

  String? get storedNationalId =>
      _client.auth.currentUser?.userMetadata?['national_id'] as String?;

  String? get currentUserEmail => _client.auth.currentUser?.email;

  Future<AuthResponse> signIn(String email, String password) =>
      _client.auth.signInWithPassword(email: email, password: password);

  Future<AuthResponse> signUp(String email, String password) =>
      _client.auth.signUp(email: email, password: password);

  Future<void> signOut() => _client.auth.signOut();

  Future<void> saveProfile({
    required String nationalId,
    required String name,
    required String phone,
    required String dob,
    required String gender,
  }) async {
    await _client.from('user').insert({
      'national_id': nationalId,
      'name': name,
      'phone_number': phone,
      'date_of_birth': dob,
      'gender': gender,
    });
    await _client.auth.updateUser(
      UserAttributes(data: {'national_id': nationalId}),
    );
  }

  Future<Map<String, dynamic>?> fetchProfile(String nationalId) async {
    final response = await _client
        .from('user')
        .select()
        .eq('national_id', nationalId)
        .maybeSingle();
    return response;
  }

  Future<void> updateProfile({
    required String nationalId,
    required String name,
    required String phone,
    required String dob,
    required String gender,
  }) async {
    await _client.from('user').update({
      'name': name,
      'phone_number': phone,
      'date_of_birth': dob,
      'gender': gender,
    }).eq('national_id', nationalId);
  }

  Future<List<Map<String, dynamic>>> fetchCars(String nationalId) async {
    final response = await _client
        .from('car')
        .select()
        .eq('national_id', nationalId);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> insertCar(Map<String, dynamic> data) async {
    await _client.from('car').insert(data);
  }

  Future<void> deleteCar(String carRegistrationId) async {
    await _client
        .from('car')
        .delete()
        .eq('car_registration_id', carRegistrationId);
  }
}
