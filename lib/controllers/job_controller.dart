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
      Get.snackbar('Error', 'Unable to fetch jobs');
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addJob(Map<String, dynamic> jobData) async {
    isLoading.value = true;
    try {
      final response = await _apiService.createJob(Get.find<AuthController>().token.value, jobData);
      if (response.isNotEmpty) {
        fetchJobs();
        Get.snackbar('Success', 'Job saved successfully', backgroundColor: Colors.green.withValues(alpha: 0.7), colorText: Colors.white);
        return true;
      }
    } catch (e) {
      Get.snackbar('Error', 'Server connection lost');
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
        Get.snackbar('Success', 'Job updated successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Unable to edit job');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteJob(String id) async {
    isLoading.value = true;
    try {
      await _apiService.deleteJob(Get.find<AuthController>().token.value, id);
      fetchJobs();
      Get.snackbar('Success', 'Job deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Unable to delete job');
    } finally {
      isLoading.value = false;
    }
  }
}
