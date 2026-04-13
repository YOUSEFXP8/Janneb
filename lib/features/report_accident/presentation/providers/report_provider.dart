import 'package:flutter/foundation.dart';

class ReportProvider extends ChangeNotifier {
  // Accident Type
  String? _selectedAccidentType;
  String? get selectedAccidentType => _selectedAccidentType;

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
  void setAccidentType(String type) {
    _selectedAccidentType = type;
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
    _selectedAccidentType = null;
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

  bool get isAccidentTypeSelected => _selectedAccidentType != null;
  bool get hasPhotos => _capturedPhotos.isNotEmpty;
  bool get hasDriverDetails =>
      _fullName.isNotEmpty &&
      _phoneNumber.isNotEmpty &&
      _vehiclePlateNumber.isNotEmpty;
}
