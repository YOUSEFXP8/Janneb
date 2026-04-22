class Car {
  final String carRegistrationId;
  final String plateNumber;
  final String manufacturer;
  final String year;
  final String insuranceCompany;

  const Car({
    required this.carRegistrationId,
    required this.plateNumber,
    required this.manufacturer,
    required this.year,
    required this.insuranceCompany,
  });

  factory Car.fromMap(Map<String, dynamic> map) {
    return Car(
      carRegistrationId: map['car_registration_id']?.toString() ?? '',
      plateNumber: map['plate_number']?.toString() ?? '',
      manufacturer: map['manufacturer']?.toString() ?? '',
      year: map['year']?.toString() ?? '',
      insuranceCompany: map['insurance_company']?.toString() ?? '',
    );
  }
}
