import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/application_model.dart';
import 'auth_controller.dart';
import 'dart:convert';

/// Controller for managing job application state and actions
class ApplicationController extends GetxController {
  final ApiService _apiService = ApiService();
  
  var applications = <Application>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyApplications();
  }

  /// Submit a new application for the given job ID
  Future<bool> apply(String jobId) async {
    try {
      isLoading.value = true;
      final token = Get.find<AuthController>().token.value;
      
      final response = await _apiService.applyForJob(token, jobId);
      
      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Application submitted successfully!');
        fetchMyApplications(); // Cusboonaysiinta liiska
        return true;
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar('Error', data['message'] ?? 'Application failed');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Connection failed');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch all applications submitted by the current user
  Future<void> fetchMyApplications() async {
    try {
      isLoading.value = true;
      final token = Get.find<AuthController>().token.value;
      if (token.isEmpty) return;

      final List<dynamic> data = await _apiService.getMyApplications(token);
      applications.value = data.map((json) => Application.fromJson(json)).toList();
    } catch (e) {
      Get.snackbar('Notice', 'Could not sync applications');
    } finally {
      isLoading.value = false;
    }
  }
}
