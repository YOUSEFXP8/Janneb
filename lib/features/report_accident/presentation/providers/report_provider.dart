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
  final List<String> _capturedPhotos = [];
  List<String> get capturedPhotos => List.unmodifiable(_capturedPhotos);

  // Location
  String _locationText = 'Amman, Jordan';
  String get locationText => _locationText;
  bool _locationConfirmed = false;
  bool get locationConfirmed => _locationConfirmed;

  // Driver Details
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

  void addPhoto(String photoPath) {
    _capturedPhotos.add(photoPath);
    notifyListeners();
  }

  void removePhoto(int index) {
    if (index >= 0 && index < _capturedPhotos.length) {
      _capturedPhotos.removeAt(index);
      notifyListeners();
    }
  }

  void setLocation(String location) {
    _locationText = location;
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
    _isLoading = false;
    _capturedPhotos.clear();
    _locationText = 'Amman, Jordan';
    _locationConfirmed = false;
    _fullName = '';
    _phoneNumber = '';
    _vehiclePlateNumber = '';
    _insuranceCompany = '';
    _accidentDescription = '';
    notifyListeners();
  }

  bool get isSessionReady => _sessionId != null;
  bool get hasPhotos => _capturedPhotos.isNotEmpty;
  bool get hasDriverDetails =>
      _fullName.isNotEmpty &&
      _phoneNumber.isNotEmpty &&
      _vehiclePlateNumber.isNotEmpty;
}
