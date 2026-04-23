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

  factory AccidentReport.fromMap(Map<String, dynamic> map) {
    return AccidentReport(
      accidentId: map['accident_id'] as int,
      latitude: (map['lat'] as num).toDouble(),
      longitude: (map['long'] as num).toDouble(),
      status: map['status'] as String,
      date: DateTime.parse(map['date'] as String),
      officerReportUrl: map['officer_report_url'] as String?,
    );
  }
}
