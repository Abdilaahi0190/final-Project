import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:5000/api';
  static const Duration timeoutDuration = Duration(seconds: 15);

  // Diiwaangelinta isticmaalaha cusub
  Future<Map<String, dynamic>> signup(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(timeoutDuration);
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Connection error: Unable to connect to server.'};
    }
  }

  // Soo gelitaanka isticmaalaha (Login)
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(timeoutDuration);
      return jsonDecode(response.body);
    } catch (e) {
      return {'message': 'Connection error: Unable to connect to server.'};
    }
  }

  // Soo qaadashada shaqooyinka oo dhan
  Future<List<dynamic>> fetchJobs() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/jobs')).timeout(timeoutDuration);
      if (response.statusCode == 200) return jsonDecode(response.body);
      return [];
    } catch (e) {
      return [];
    }
  }

  // Abuurista shaqo cusub (Admin kaliya)
  Future<Map<String, dynamic>> createJob(String token, Map<String, dynamic> jobData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/jobs'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode(jobData),
    ).timeout(timeoutDuration);
    return jsonDecode(response.body);
  }

  // Wax ka beddelka shaqo jirta
  Future<Map<String, dynamic>?> updateJob(String token, String id, Map<String, dynamic> jobData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/jobs/$id'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode(jobData),
    ).timeout(timeoutDuration);
    if (response.statusCode == 200) return jsonDecode(response.body);
    return null;
  }

  // Tirtirida shaqo
  Future<bool> deleteJob(String token, String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/jobs/$id'),
      headers: {'Authorization': 'Bearer $token'},
    ).timeout(timeoutDuration);
    return response.statusCode == 200;
  }

  // Soo qaadashada isticmaalayaasha (Admin kaliya)
  Future<List<dynamic>> getUsers(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/users'),
      headers: {'Authorization': 'Bearer $token'},
    ).timeout(timeoutDuration);
    if (response.statusCode == 200) return jsonDecode(response.body);
    return [];
  }

  // Abuurista isticmaale cusub
  Future<Map<String, dynamic>> createUser(String token, Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode(userData),
    ).timeout(timeoutDuration);
    return jsonDecode(response.body);
  }

  // Wax ka beddelka macluumaadka isticmaalaha
  Future<Map<String, dynamic>?> updateUser(String token, String id, Map<String, dynamic> userData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/$id'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode(userData),
    ).timeout(timeoutDuration);
    if (response.statusCode == 200) return jsonDecode(response.body);
    return null;
  }

  // Tirtirida isticmaale
  Future<bool> deleteUser(String token, String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/users/$id'),
      headers: {'Authorization': 'Bearer $token'},
    ).timeout(timeoutDuration);
    return response.statusCode == 200;
  }
}
