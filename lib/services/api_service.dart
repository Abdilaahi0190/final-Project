import 'dart:convert';
import 'package:http/http.dart' as http;

/// Adeeg dib loo isticmaali karo oo loogu talagalay dhammaan isgaarsiinta backend API
class ApiService {
  // Isticmaal 10.0.2.2 loogu talagalay Android Emulator (backend deegaanka ah)
  // Isticmaal localhost loogu talagalay iOS Simulator
  static const String baseUrl = 'https://final-project-a4kk.onrender.com/api';
  
  // Muddada wakhtiga laga sugayo codsiyada
  static const Duration timeoutDuration = Duration(seconds: 15);

  // --- Xaqiijinta (Authentication) ---

  /// Diwaangeli isticmaale cusub
  Future<http.Response> register(String email, String password) async {
    final url = Uri.parse('$baseUrl/signup');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    ).timeout(timeoutDuration);
  }

  /// Soo gal oo hel token
  Future<http.Response> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    ).timeout(timeoutDuration);
  }

  // --- Shaqooyinka (Jobs) ---

  /// Soo kibi dhammaan shaqooyinka bannaan
  Future<List<dynamic>> getJobs() async {
    final url = Uri.parse('$baseUrl/jobs');
    final response = await http.get(url).timeout(timeoutDuration);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Ku guuldareysiga soo kicinta shaqooyinka');
    }
  }

  /// Abuur shaqo cusub (Admin kaliya)
  Future<http.Response> createJob(String token, Map<String, dynamic> jobData) async {
    final url = Uri.parse('$baseUrl/jobs');
    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(jobData),
    ).timeout(timeoutDuration);
  }

  /// Cusboonaysii shaqo jirta (Admin kaliya)
  Future<http.Response> updateJob(String token, String jobId, Map<String, dynamic> jobData) async {
    final url = Uri.parse('$baseUrl/jobs/$jobId');
    return await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(jobData),
    ).timeout(timeoutDuration);
  }

  /// Tirtir shaqo (Admin kaliya)
  Future<http.Response> deleteJob(String token, String jobId) async {
    final url = Uri.parse('$baseUrl/jobs/$jobId');
    return await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(timeoutDuration);
  }

  // --- Maamulka Isticmaalaha (Admin kaliya) ---

  /// Soo kibi dhammaan isticmaalayaasha
  Future<List<dynamic>> getUsers(String token) async {
    final url = Uri.parse('$baseUrl/users');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(timeoutDuration);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Ku guuldareysiga soo kicinta isticmaalayaasha');
    }
  }

  /// Abuur isticmaale cusub gacanta
  Future<http.Response> createUser(String token, Map<String, dynamic> userData) async {
    final url = Uri.parse('$baseUrl/users');
    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(userData),
    ).timeout(timeoutDuration);
  }

  /// Cusboonaysii faahfaahinta isticmaalaha ama doorka
  Future<http.Response> updateUser(String token, String userId, Map<String, dynamic> userData) async {
    final url = Uri.parse('$baseUrl/users/$userId');
    return await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(userData),
    ).timeout(timeoutDuration);
  }

  /// Tirtir isticmaale
  Future<http.Response> deleteUser(String token, String userId) async {
    final url = Uri.parse('$baseUrl/users/$userId');
    return await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(timeoutDuration);
  }

  // --- Codsiyada (Applications) ---

  /// Gudbi codsi shaqo
  Future<http.Response> applyForJob(String token, String jobId) async {
    final url = Uri.parse('$baseUrl/applications/apply');
    return await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'jobId': jobId}),
    ).timeout(timeoutDuration);
  }

  /// Soo kibi codsiyada isticmaalaha hadda jira
  Future<List<dynamic>> getMyApplications(String token) async {
    final url = Uri.parse('$baseUrl/applications/my-applications');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(timeoutDuration);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Ku guuldareysiga soo kicinta codsiyada');
    }
  }

  /// Soo kibi codsiyada shaqo gaar ah (Admin kaliya)
  Future<List<dynamic>> getJobApplications(String token, String jobId) async {
    final url = Uri.parse('$baseUrl/applications/job/$jobId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    ).timeout(timeoutDuration);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Ku guuldareysiga soo kicinta codsiyada shaqada');
    }
  }
}
