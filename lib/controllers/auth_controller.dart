import 'package:get/get.dart';
import '../services/api_service.dart';

// Kani waa maamulaha xaqiijinta (AuthController) oo isticmaalaya GetX
// Wuxuu mas'uul ka yahay soo gelitaanka (login), diiwaangelinta (signup) iyo ka bixitaanka (logout)
class AuthController extends GetxController {
  final ApiService _apiService = ApiService();
  
  // Rx Strings waxay u ogolaaneysaa GetX inuu si toos ah u cusbooneysiiyo UI-ga
  var token = ''.obs;
  var email = ''.obs;
  var role = 'job_seeker'.obs; // Doorka default-ka ah
  var isLoading = false.obs;

  // Shaqadani waxay u ogolaaneysaa isticmaalaha inuu is-diiwaangeliyo
  Future<String?> signup(String emailVal, String passwordVal) async {
    isLoading.value = true;
    try {
      final response = await _apiService.signup(emailVal, passwordVal);
      isLoading.value = false;

      if (response.containsKey('token')) {
        token.value = response['token'];
        email.value = response['email'];
        role.value = response['role'] ?? 'job_seeker';
        return null; // Guul (Success)
      }
      // Haddii fariin gaar ah ka timaado backend-ka
      return response['message'] ?? response['error'] ?? 'Khalad aan la garanayn ayaa dhacay';
    } catch (e) {
      isLoading.value = false;
      return 'Lama xiriiri karo server-ka';
    }
  }

  // Shaqadani waxay u ogolaaneysaa isticmaalaha inuu soo galo abka
  Future<String?> login(String emailVal, String passwordVal) async {
    isLoading.value = true;
    try {
      final response = await _apiService.login(emailVal, passwordVal);
      isLoading.value = false;

      if (response.containsKey('token')) {
        token.value = response['token'];
        email.value = response['email'];
        role.value = response['role'] ?? 'job_seeker';
        return null; // Guul
      }
      return response['message'] ?? 'Email-ka ama Lambarka sirta ah waa khalad';
    } catch (e) {
      isLoading.value = false;
      return 'Lama xiriiri karo server-ka';
    }
  }

  // Shaqadani waxay ka saareysaa isticmaalaha abka
  void logout() {
    token.value = '';
    email.value = '';
    Get.offAllNamed('/login'); // Tag bogga login-ka
  }
}
