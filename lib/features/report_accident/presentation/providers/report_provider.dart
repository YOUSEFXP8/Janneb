import 'dart:io';
import 'dart:math';
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

  // QR Session
  String? _sessionId;
  String? get sessionId => _sessionId;

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

  // Accident-specific details
  String _accidentType = '';
  String get accidentType => _accidentType;

  String _weatherCondition = '';
  String get weatherCondition => _weatherCondition;

  bool _injuriesReported = false;
  bool get injuriesReported => _injuriesReported;

  // Generate a local join code; actual accident record is created at review/submit time.
  Future<void> createSession() async {
    _isLoading = true;
    notifyListeners();
    try {
      final rand = Random.secure();
      _sessionId = List.generate(6, (_) => rand.nextInt(10)).join();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Called by QR scanner path — stores the scanned code locally.
  // TODO: also call join_accident RPC here once car selection is added to the scanner flow.
  Future<void> joinSession(String id) async {
    _sessionId = id;
    notifyListeners();
  }

  // Called by manual join code path — calls join_accident RPC.
  Future<void> joinAccident({
    required String joinCode,
    required String nationalId,
    required String carRegistrationId,
  }) async {
    _isLoading = true;
    _reportError = null;
    notifyListeners();
    try {
      final client = Supabase.instance.client;
      await client.rpc('join_accident', params: {
        'p_join_code': joinCode,
        'p_national_id': nationalId,
        'p_car_registration_id': carRegistrationId,
        'p_statement': '',
      });
      _sessionId = joinCode;
    } on PostgrestException {
      rethrow;
    } catch (_) {
      _reportError = 'Failed to join accident';
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Called from ReviewScreen on submit — creates the accident record and uploads media.
  Future<void> submitReport() async {
    _isLoading = true;
    _reportError = null;
    notifyListeners();
    try {
      final client = Supabase.instance.client;
      final nationalId =
          client.auth.currentUser?.userMetadata?['national_id'] as String?;
      final result = await client.rpc('create_accident', params: {
        'p_national_id': nationalId,
        'p_car_registration_id': _selectedCar?['car_registration_id'],
        'p_lat': _latitude,
        'p_long': _longitude,
        'p_statement': _accidentDescription,
      });
      final accidentId = result['accident_id'] as int?;
      _lastAccidentId = accidentId;

      // Upload captured images to accident-media bucket.
      if (accidentId != null) {
        for (int i = 0; i < _images.length; i++) {
          try {
            final path =
                '$accidentId/${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
            await client.storage.from('accident-media').upload(
                  path,
                  _images[i],
                  fileOptions: const FileOptions(
                    contentType: 'image/jpeg',
                    upsert: true,
                  ),
                );
            final url =
                client.storage.from('accident-media').getPublicUrl(path);
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
            (r) => AccidentReport.fromMap(r['accident'] as Map<String, dynamic>),
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
    required String accidentType,
    required String weatherCondition,
    required bool injuriesReported,
  }) {
    _fullName = fullName;
    _phoneNumber = phoneNumber;
    _vehiclePlateNumber = vehiclePlateNumber;
    _insuranceCompany = insuranceCompany;
    _accidentDescription = accidentDescription;
    _accidentType = accidentType;
    _weatherCondition = weatherCondition;
    _injuriesReported = injuriesReported;
    notifyListeners();
  }

  void resetReport() {
    _sessionId = null;
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
    _accidentType = '';
    _weatherCondition = '';
    _injuriesReported = false;
    _lastAccidentId = null;
    _reportError = null;
    notifyListeners();
  }

  bool get isSessionReady => _sessionId != null;
  bool get hasPhotos => _images.isNotEmpty;
  bool get hasDriverDetails =>
      _fullName.isNotEmpty &&
      _phoneNumber.isNotEmpty &&
      _vehiclePlateNumber.isNotEmpty;
}
