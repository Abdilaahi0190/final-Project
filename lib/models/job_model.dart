/// Represents a job listing in the application
class Job {
  final String id;
  final String title;
  final String company;
  final String salary;
  final String type;
  final String location;
  final String description;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.salary,
    required this.type,
    required this.location,
    required this.description,
  });

  /// Factory constructor to create a Job object from JSON data
  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      salary: json['salary'] ?? '',
      type: json['type'] ?? '',
      location: json['location'] ?? '',
      description: json['description'] ?? '',
    );
  }
}
