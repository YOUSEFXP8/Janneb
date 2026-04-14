class AccidentReport {
  final int accidentId;
  final double latitude;
  final double longitude;
  final String status;
  final DateTime date;
  final String? officerReportUrl;

  const AccidentReport({
    required this.accidentId,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.date,
    this.officerReportUrl,
  });
}
