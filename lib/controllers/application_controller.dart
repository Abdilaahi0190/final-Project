import 'package:get/get.dart';
import '../services/api_service.dart';
import '../models/application_model.dart';
import 'auth_controller.dart';
import 'dart:convert';

/// Controller-ka loogu talagalay maareynta xaaladda codsiyada shaqada iyo ficillada
class ApplicationController extends GetxController {
  final ApiService _apiService = ApiService();
  
  var applications = <Application>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyApplications();
  }

  /// Gudbinta codsi cusub oo loogu talagalay aqoonsiga shaqada (job ID) la bixiyay
  Future<bool> apply(String jobId) async {
    try {
      isLoading.value = true;
      final token = Get.find<AuthController>().token.value;
      
      final response = await _apiService.applyForJob(token, jobId);
      
      if (response.statusCode == 201) {
        Get.snackbar('Guul', 'Codsiga waa la gudbiyay si guul leh!');
        fetchMyApplications(); // Cusboonaysiinta liiska
        return true;
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar('Khalad', data['message'] ?? 'Waa lagu guuldareystay codsiga');
        return false;
      }
    } catch (e) {
      Get.snackbar('Khalad', 'Xiriirka waa uu guuldareystay');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Soo qaadashada dhammaan codsiyada uu gudbiyay isticmaalaha hadda jooga
  Future<void> fetchMyApplications() async {
    try {
      isLoading.value = true;
      final token = Get.find<AuthController>().token.value;
      if (token.isEmpty) return;

      final List<dynamic> data = await _apiService.getMyApplications(token);
      applications.value = data.map((json) => Application.fromJson(json)).toList();
    } catch (e) {
      Get.snackbar('Ogeysiis', 'Ma suurtagelin in la waafajiyo codsiyada');
    } finally {
      isLoading.value = false;
    }
  }
}
