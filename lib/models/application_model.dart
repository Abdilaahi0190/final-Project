import 'job_model.dart';

/// Represents a user's application for a specific job
class Application {
  final String id;
  final Job job;
  final String applicantId;
  final String status;
  final DateTime appliedAt;

  Application({
    required this.id,
    required this.job,
    required this.applicantId,
    required this.status,
    required this.appliedAt,
  });

  /// Factory constructor to create an Application object from JSON data
  factory Application.fromJson(Map<String, dynamic> json) {
    return Application(
      id: json['_id'] ?? '',
      job: Job.fromJson(json['job'] ?? {}),
      applicantId: json['applicant'] is String ? json['applicant'] : (json['applicant']['_id'] ?? ''),
      status: json['status'] ?? 'Pending',
      appliedAt: DateTime.parse(json['appliedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}
