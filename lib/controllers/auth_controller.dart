import 'package:get/get.dart';
import '../services/api_service.dart';
import 'dart:convert';

/// Controller-ka loogu talagalay inuu maareeyo xaqiijinta isticmaalaha iyo xaaladda kalfadhiga
class AuthController extends GetxController {
  final ApiService _apiService = ApiService();
  
  // Isbeddellada la arki karo (Observable variables) ee loogu talagalay cusboonaysiinta UI ee waqtiga dhabta ah
  var token = ''.obs;
  var email = ''.obs;
  var role = 'job_seeker'.obs; 
  var isLoading = false.obs;

  /// Is-diiwaangelinta akoon isticmaale oo cusub
  Future<String?> signup(String emailVal, String passwordVal) async {
    isLoading.value = true;
    try {
      final response = await _apiService.register(emailVal, passwordVal);
      isLoading.value = false;

      final data = jsonDecode(response.body);
      if (response.statusCode == 201) {
        token.value = data['token'];
        email.value = data['email'];
        role.value = data['role'] ?? 'job_seeker';
        return null; // Is-diiwaangelintu waa lagu guuleystay
      }
      return data['message'] ?? data['error'] ?? 'Khalad aan la garanayn ayaa dhacay';
    } catch (e) {
      isLoading.value = false;
      return 'Xiriirka waa uu guuldareystay. Fadlan hubi internet-kaaga.';
    }
  }

  /// Xaqiijinta isticmaalaha iyo bilaabista kalfadhiga (Login)
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
        return null; // Soo gelitaanku waa lagu guuleystay
      }
      return data['message'] ?? 'Email ama password khaldan';
    } catch (e) {
      isLoading.value = false;
      return 'Xiriirka waa uu guuldareystay. Fadlan hubi internet-kaaga.';
    }
  }

  /// Nadiifinta kalfadhiga iyo u gudubka shaashadda soo gelitaanka
  void logout() {
    token.value = '';
    email.value = '';
    Get.offAllNamed('/login');
  }
}
