import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/job_model.dart';
import '../services/api_service.dart';
import 'auth_controller.dart';

class JobController extends GetxController {
  final ApiService _apiService = ApiService();
  
  var jobs = <Job>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    isLoading.value = true;
    try {
      final List<dynamic> jobsData = await _apiService.fetchJobs();
      jobs.value = jobsData.map((json) => Job.fromJson(json)).toList();
    } catch (e) {
      Get.snackbar('Khalad', 'Lama soo qaadi karo shaqooyinka');
    } finally {
      isLoading.value = false;
    }
  }

  // Alias for addJob to fix error shown in screenshot where createJob is called
  Future<bool> createJob(Map<String, dynamic> jobData) => addJob(jobData);

  Future<bool> addJob(Map<String, dynamic> jobData) async {
    isLoading.value = true;
    try {
      final response = await _apiService.createJob(Get.find<AuthController>().token.value, jobData);
      if (response.isNotEmpty) {
        fetchJobs();
        Get.snackbar(
          'Guul', 
          'Shaqada si guul leh ayaa loo keydiyay', 
          backgroundColor: Colors.green.withValues(alpha: 0.7), 
          colorText: Colors.white
        );
        return true;
      }
    } catch (e) {
      Get.snackbar('Khalad', 'Xiriirka server-ka ayaa lumay');
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  Future<void> updateJob(String id, Map<String, dynamic> jobData) async {
    isLoading.value = true;
    try {
      final response = await _apiService.updateJob(Get.find<AuthController>().token.value, id, jobData);
      if (response != null) {
        fetchJobs();
        Get.snackbar('Guul', 'Shaqada si guul leh ayaa loo cusbooneysiiyay');
      }
    } catch (e) {
      Get.snackbar('Khalad', 'Lama beddeli karo shaqada');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteJob(String id) async {
    isLoading.value = true;
    try {
      await _apiService.deleteJob(Get.find<AuthController>().token.value, id);
      fetchJobs();
      Get.snackbar('Guul', 'Shaqada si guul leh ayaa loo tirtiray');
    } catch (e) {
      Get.snackbar('Khalad', 'Lama tirtiri karo shaqada');
    } finally {
      isLoading.value = false;
    }
  }
}
