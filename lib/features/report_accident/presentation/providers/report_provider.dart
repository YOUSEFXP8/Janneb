import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../data/models/accident_report.dart';

class ReportProvider extends ChangeNotifier {
  // Mock Reports
  final List<AccidentReport> _reports = [
    AccidentReport(
      accidentId: 4821,
      latitude: 24.7136,
      longitude: 46.6753,
      status: 'UNDER_REVIEW',
      date: DateTime(2026, 4, 13),
    ),
    AccidentReport(
      accidentId: 4822,
      latitude: 24.7136,
      longitude: 46.6753,
      status: 'COMPLETED',
      date: DateTime(2026, 4, 10),
      officerReportUrl: 'https://example.com/report_4822.pdf',
    ),
    AccidentReport(
      accidentId: 4823,
      latitude: 24.7136,
      longitude: 46.6753,
      status: 'REPORTED',
      date: DateTime(2026, 4, 14),
    ),
  ];

  List<AccidentReport> get reports => List.unmodifiable(_reports);

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

  // Evidence / Photos (real File objects)
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

  // Selected Car (from user's registered vehicles)
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

  // Methods
  Future<void> createSession() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    _sessionId = 'ACC-12345';
    _isLoading = false;
    notifyListeners();
  }

  Future<void> joinSession(String id) async {
    _sessionId = id;
    notifyListeners();
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
    notifyListeners();
  }

  bool get isSessionReady => _sessionId != null;
  bool get hasPhotos => _images.isNotEmpty;
  bool get hasDriverDetails =>
      _fullName.isNotEmpty &&
      _phoneNumber.isNotEmpty &&
      _vehiclePlateNumber.isNotEmpty;
}
