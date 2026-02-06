import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../controllers/job_controller.dart';
import '../../widgets/job_card.dart';

/// Screen to display a full list of all available job postings
class AllJobsScreen extends StatelessWidget {
  const AllJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final JobController jobController = Get.find<JobController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Available Jobs',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (jobController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (jobController.jobs.isEmpty) {
          return Center(
            child: Text('No jobs available at the moment', style: GoogleFonts.poppins()),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: jobController.jobs.length,
          itemBuilder: (context, index) {
            final job = jobController.jobs[index];
            return JobCard(job: job);
          },
        );
      }),
    );
  }
}
