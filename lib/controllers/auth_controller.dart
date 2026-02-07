import 'package:get/get.dart';
import '../services/api_service.dart';
import 'dart:convert';

/// Controller ka maamula xaqiijinta isticmaalaha iyo xaaladda kalfadhiga
class AuthController extends GetxController {
  final ApiService _apiService = ApiService();
  
  // Isbeddellada la heli karo si loo cusboonaysiiyo UI-ga waqtiga dhabta ah
  var token = ''.obs;
  var email = ''.obs;
  var role = 'job_seeker'.obs; 
  var isLoading = false.obs;

  /// Diwaangeli koonto cusub oo isticmaale
  Future<String?> signup(String emailVal, String passwordVal) async {
    isLoading.value = true; // Bilaabista rarka (loading)
    try {
      final response = await _apiService.register(emailVal, passwordVal);
      isLoading.value = false; // Joojinta rarka

      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        token.value = data['token'];
        email.value = data['email'];
        role.value = data['role'] ?? 'job_seeker';
        return null; // Diwaangelintu waa guul
      }
      return data['message'] ?? data['error'] ?? 'Khalad aan la garanayn ayaa dhacay';
    } catch (e) {
      isLoading.value = false;
      return 'Xidhiidhku waa fashilmay. Fadlan hubi internet-kaaga.';
    }
  }

  /// Xaqiijinta isticmaalaha iyo bilawga kalfadhiga (Login)
  Future<String?> login(String emailVal, String passwordVal) async {
    isLoading.value = true;
    try {
      final response = await _apiService.login(emailVal, passwordVal);
      isLoading.value = false;

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        token.value = data['token'];
        email.value = data['email'];
        role.value = data['role'] ?? 'job_seeker';
        return null; // Soo gelitaanku waa guul
      }
      return data['message'] ?? 'Email ama password khaldan';
    } catch (e) {
      isLoading.value = false;
      return 'Xidhiidhku waa fashilmay. Fadlan hubi internet-kaaga.';
    }
  }

  /// Nadiifi kalfadhiga oo u gudub bogga soo gelitaanka
  void logout() {
    token.value = '';
    email.value = '';
    Get.offAllNamed('/login');
  }
}
