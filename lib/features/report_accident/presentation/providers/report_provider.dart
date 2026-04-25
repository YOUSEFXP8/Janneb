import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/accident_report.dart';

class ReportProvider extends ChangeNotifier {
  final List<AccidentReport> _reports = [];

  List<AccidentReport> get reports => List.unmodifiable(_reports);

  int? _lastAccidentId;
  int? get lastAccidentId => _lastAccidentId;

  String? _reportError;
  String? get reportError => _reportError;

  // Guide Step tracking
  int _guideStep = 0;
  int get guideStep => _guideStep;
  void setGuideStep(int step) {
    _guideStep = step;
    notifyListeners();
  }

  AccidentReport getReportById(int id) {
    return _reports.firstWhere(
      (report) => report.accidentId == id,
      orElse: () => throw Exception('Report not found'),
    );
  }

  // Server-assigned join_code (set after createSession or at submit for joiner).
  String? _sessionId;
  String? get sessionId => _sessionId;

  // accident_id returned by create_accident when creator calls createSession().
  int? _accidentId;

  bool _isJoiningSession = false;
  bool get isJoiningSession => _isJoiningSession;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Evidence / Photos
  final List<File> _images = [];
  List<File> get images => List.unmodifiable(_images);

  // Location
  String _locationText = 'Amman, Jordan';
  String get locationText => _locationText;
  bool _locationConfirmed = false;
  bool get locationConfirmed => _locationConfirmed;

  // GPS Coordinates
  double? _latitude;
  double? _longitude;
  double? get latitude => _latitude;
  double? get longitude => _longitude;

  // Selected Car
  Map<String, dynamic>? _selectedCar;
  Map<String, dynamic>? get selectedCar => _selectedCar;
  void selectCar(Map<String, dynamic>? car) {
    _selectedCar = car;
    notifyListeners();
  }

  // Driver / Reporter Details
  String _fullName = '';
  String get fullName => _fullName;

  String _phoneNumber = '';
  String get phoneNumber => _phoneNumber;

  String _vehiclePlateNumber = '';
  String get vehiclePlateNumber => _vehiclePlateNumber;

  String _insuranceCompany = '';
  String get insuranceCompany => _insuranceCompany;

  String _accidentDescription = '';
  String get accidentDescription => _accidentDescription;

  // Creator path: calls create_accident immediately so the join_code is available
  // as a QR code before the other party needs to scan it.
  Future<void> createSession({
    required String nationalId,
    required String carRegistrationId,
    required double lat,
    required double lng,
  }) async {
    _isLoading = true;
    _reportError = null;
    notifyListeners();
    try {
      final client = Supabase.instance.client;
      final result = await client.rpc('create_accident', params: {
        'p_national_id': nationalId,
        'p_car_registration_id': carRegistrationId,
        'p_lat': lat,
        'p_long': lng,
        'p_statement': '',
      });
      _sessionId = result['join_code'] as String?;
      _accidentId = result['accident_id'] as int?;
      _isJoiningSession = false;
      _latitude = lat;
      _longitude = lng;
    } on PostgrestException catch (e) {
      _reportError = e.message;
      rethrow;
    } catch (_) {
      _reportError = 'Failed to create session';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // QR scanner path: stores the scanned server-assigned join_code.
  void joinSession(String joinCode) {
    _sessionId = joinCode;
    _isJoiningSession = true;
    notifyListeners();
  }

  // Manual code entry path: stores the entered code for use at submit time.
  // Actual validation against the DB happens when submitReport() is called.
  void joinAccident({required String joinCode}) {
    _sessionId = joinCode;
    _isJoiningSession = true;
    notifyListeners();
  }

  // Called from ReviewScreen on submit.
  // Creator: calls create_accident RPC, stores returned join_code for the success screen.
  // Joiner: calls join_accident RPC with the previously scanned/entered join_code.
  Future<void> submitReport() async {
    _isLoading = true;
    _reportError = null;
    notifyListeners();
    try {
      final client = Supabase.instance.client;
      final nationalId =
          client.auth.currentUser?.userMetadata?['national_id'] as String?;

      if (_isJoiningSession) {
        // Joiner: link to the existing accident created by the other party.
        final result = await client.rpc(
          'join_accident',
          params: {
            'p_join_code': _sessionId,
            'p_national_id': nationalId,
            'p_car_registration_id': _selectedCar?['car_registration_id'],
            'p_statement': _accidentDescription,
          },
        );
        _lastAccidentId = result?['accident_id'] as int?;
      } else {
        _lastAccidentId = _accidentId;
        
        // Update the statement and selected car, since they were filled out after createSession
        if (_accidentId != null && nationalId != null) {
          await client.from('accident_party').update({
            'car_registration_id': _selectedCar?['car_registration_id'],
            'statement': _accidentDescription,
          }).eq('accident_id', _accidentId!).eq('national_id', nationalId);
        }
      }

      // Upload captured images to accident-media bucket.
      final accidentId = _lastAccidentId;
      if (accidentId != null) {
        for (int i = 0; i < _images.length; i++) {
          try {
            final path =
                '$accidentId/${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
            await client.storage
                .from('accident-media')
                .upload(
                  path,
                  _images[i],
                  fileOptions: const FileOptions(
                    contentType: 'image/jpeg',
                    upsert: true,
                  ),
                );
            final url = client.storage
                .from('accident-media')
                .getPublicUrl(path);
            await client.from('accident_media').insert({
              'accident_id': accidentId,
              'file_url': url,
              'media_type': 'image',
            });
          } catch (_) {
            // Skip failed uploads — don't abort the whole submission.
          }
        }
      }
    } on PostgrestException catch (e) {
      _reportError = e.message;
      rethrow;
    } catch (_) {
      _reportError = 'Failed to submit report';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetches all accidents where the user is a party.
  Future<void> fetchReports(String nationalId) async {
    _isLoading = true;
    _reportError = null;
    notifyListeners();
    try {
      final client = Supabase.instance.client;
      final response = await client
          .from('accident_party')
          .select('accident(*)')
          .eq('national_id', nationalId);
      _reports
        ..clear()
        ..addAll(
          (response as List).map(
            (r) =>
                AccidentReport.fromMap(r['accident'] as Map<String, dynamic>),
          ),
        )
        ..sort((a, b) => b.date.compareTo(a.date));
    } on PostgrestException catch (e) {
      _reportError = e.message;
    } catch (_) {
      _reportError = 'Failed to load reports';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void resetSession() {
    _sessionId = null;
    _accidentId = null;
    _isJoiningSession = false;
    notifyListeners();
  }

  void addImage(File image) {
    _images.add(image);
    notifyListeners();
  }

  void removeImage(int index) {
    if (index >= 0 && index < _images.length) {
      _images.removeAt(index);
      notifyListeners();
    }
  }

  void setLocation(String location) {
    _locationText = location;
    notifyListeners();
  }

  void setGpsCoordinates(double lat, double lng) {
    _latitude = lat;
    _longitude = lng;
    notifyListeners();
  }

  void confirmLocation() {
    _locationConfirmed = true;
    notifyListeners();
  }

  void setDriverDetails({
    required String fullName,
    required String phoneNumber,
    required String vehiclePlateNumber,
    required String insuranceCompany,
    required String accidentDescription,
  }) {
    _fullName = fullName;
    _phoneNumber = phoneNumber;
    _vehiclePlateNumber = vehiclePlateNumber;
    _insuranceCompany = insuranceCompany;
    _accidentDescription = accidentDescription;
    notifyListeners();
  }

  void resetReport() {
    _sessionId = null;
    _accidentId = null;
    _isJoiningSession = false;
    _isLoading = false;
    _images.clear();
    _locationText = 'Amman, Jordan';
    _locationConfirmed = false;
    _latitude = null;
    _longitude = null;
    _selectedCar = null;
    _fullName = '';
    _phoneNumber = '';
    _vehiclePlateNumber = '';
    _insuranceCompany = '';
    _accidentDescription = '';
    _lastAccidentId = null;
    _reportError = null;
    notifyListeners();
  }

  bool get isSessionReady => true; // Creator no longer needs a pre-generated code
  bool get hasPhotos => _images.isNotEmpty;
  bool get hasDriverDetails =>
      _fullName.isNotEmpty &&
      _phoneNumber.isNotEmpty &&
      _vehiclePlateNumber.isNotEmpty;
}
