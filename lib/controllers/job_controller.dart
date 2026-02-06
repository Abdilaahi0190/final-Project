import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/job_model.dart';
import '../services/api_service.dart';
import 'auth_controller.dart';

/// Controller-ka loogu talagalay maareynta xogta shaqada iyo kala shaandheynta
class JobController extends GetxController {
  final ApiService _apiService = ApiService();
  
  var jobs = <Job>[].obs;
  var filteredJobs = <Job>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobs();
  }

  /// Kala shaandheynta shaqooyinka iyadoo loo eegayo cinwaanka ama shirkadda
  void filterJobs(String query) {
    if (query.isEmpty) {
      filteredJobs.value = jobs;
    } else {
      filteredJobs.value = jobs
          .where((job) =>
              job.title.toLowerCase().contains(query.toLowerCase()) ||
              job.company.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  /// Soo qaadashada dhammaan shaqooyinka ka imanaya server-ka
  Future<void> fetchJobs() async {
    isLoading.value = true;
    try {
      final List<dynamic> jobsData = await _apiService.getJobs();
      jobs.value = jobsData.map((json) => Job.fromJson(json)).toList();
      filteredJobs.value = jobs; 
    } catch (e) {
      Get.snackbar('Khalad', 'Waa lagu guuldareystay soo qaadashada shaqooyinka');
    } finally {
      isLoading.value = false;
    }
  }

  /// Naanays loo bixiyay addJob si loo hubiyo isku-mid ahaanshaha
  Future<bool> createJob(Map<String, dynamic> jobData) => addJob(jobData);

  /// Gudbinta shaqo cusub server-ka (Admin kaliya)
  Future<bool> addJob(Map<String, dynamic> jobData) async {
    isLoading.value = true;
    try {
      final response = await _apiService.createJob(Get.find<AuthController>().token.value, jobData);
      if (response.statusCode == 201) {
        fetchJobs(); // Cusboonaysiinta liiska maxalliga ah
        Get.snackbar(
          'Guul', 
          'Shaqada waa la dhajiyay si guul leh!', 
          backgroundColor: Colors.green.withValues(alpha: 0.7), 
          colorText: Colors.white
        );
        return true;
      }
    } catch (e) {
      Get.snackbar('Khalad', 'Waa lagu guuldareystay xiriirka server-ka');
    } finally {
      isLoading.value = false;
    }
    return false;
  }

  /// Cusboonaysiinta shaqo jirta (Admin kaliya)
  Future<void> updateJob(String id, Map<String, dynamic> jobData) async {
    isLoading.value = true;
    try {
      final response = await _apiService.updateJob(Get.find<AuthController>().token.value, id, jobData);
      if (response.statusCode == 200) {
        fetchJobs();
        Get.snackbar('Guul', 'Shaqada waa la cusboonaysiiyay si guul leh');
      }
    } catch (e) {
      Get.snackbar('Khalad', 'Waa lagu guuldareystay cusboonaysiinta shaqada');
    } finally {
      isLoading.value = false;
    }
  }

  /// Tiridda shaqo (Admin kaliya)
  Future<void> deleteJob(String id) async {
    isLoading.value = true;
    try {
      await _apiService.deleteJob(Get.find<AuthController>().token.value, id);
      fetchJobs();
      Get.snackbar('Guul', 'Shaqada waa la tiray si guul leh');
    } catch (e) {
      Get.snackbar('Khalad', 'Waa lagu guuldareystay tiridda shaqada');
    } finally {
      isLoading.value = false;
    }
  }
}
