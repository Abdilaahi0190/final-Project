/// Represents a job listing in the application
class Job {
  final String id;
  final String title;
  final String company;
  final String salary;
  final String type;
  final String location;
  final String description;
  final String logo;
  final String color;

  Job({
    required this.id,
    required this.title,
    required this.company,
    required this.salary,
    required this.type,
    required this.location,
    required this.description,
    required this.logo,
    required this.color,
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
      logo: json['logo'] ?? 'work',
      color: json['color'] ?? '0xFF667eea',
    );
  }
}
