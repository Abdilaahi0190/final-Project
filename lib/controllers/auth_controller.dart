import 'package:get/get.dart';
import '../services/api_service.dart';

// This is the authentication control (AuthController) that uses GetX
// It is responsible for entry (login), registration (signup) and exit (logout)
class AuthController extends GetxController {
  final ApiService _apiService = ApiService();
  
  // Rx Strings allow GetX to automatically update the UI
  var token = ''.obs;
  var email = ''.obs;
  var role = 'job_seeker'.obs; // Default role
  var isLoading = false.obs;

  // This function allows the user to register
  Future<String?> signup(String emailVal, String passwordVal) async {
    isLoading.value = true;
    try {
      final response = await _apiService.signup(emailVal, passwordVal);
      isLoading.value = false;

      if (response.containsKey('token')) {
        token.value = response['token'];
        email.value = response['email'];
        role.value = response['role'] ?? 'job_seeker';
        return null; // Success
      }
      // If there is a specific message from the backend
      return response['message'] ?? response['error'] ?? 'An unknown error occurred';
    } catch (e) {
      isLoading.value = false;
      return 'Unable to connect to server';
    }
  }

  // This function allows the user to enter the app
  Future<String?> login(String emailVal, String passwordVal) async {
    isLoading.value = true;
    try {
      final response = await _apiService.login(emailVal, passwordVal);
      isLoading.value = false;

      if (response.containsKey('token')) {
        token.value = response['token'];
        email.value = response['email'];
        role.value = response['role'] ?? 'job_seeker';
        return null; // Success
      }
      return response['message'] ?? 'Email or Password is wrong';
    } catch (e) {
      isLoading.value = false;
      return 'Unable to connect to server';
    }
  }

  // This function removes the user from the app
  void logout() {
    token.value = '';
    email.value = '';
    Get.offAllNamed('/login'); // Go to login page
  }
}
