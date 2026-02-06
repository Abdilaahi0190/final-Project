import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/application_controller.dart';
import '../../widgets/job_card.dart';

class MyApplicationsScreen extends StatefulWidget {
  const MyApplicationsScreen({super.key});

  @override
  State<MyApplicationsScreen> createState() => _MyApplicationsScreenState();
}

class _MyApplicationsScreenState extends State<MyApplicationsScreen> {
  final ApplicationController applicationController = Get.find<ApplicationController>();

  @override
  void initState() {
    super.initState();
    applicationController.fetchMyApplications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'My Applications',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: Obx(() {
        if (applicationController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (applicationController.applications.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment_late_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'No applications yet',
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: applicationController.applications.length,
          itemBuilder: (context, index) {
            final app = applicationController.applications[index];
            
            // get status color
            Color statusColor;
            if (app.status == 'Accepted') {
              statusColor = Colors.green;
            } else if (app.status == 'Rejected') {
              statusColor = Colors.red;
            } else if (app.status == 'Reviewed') {
              statusColor = Colors.blue;
            } else {
              statusColor = Colors.orange;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Stack(
                children: [
                   // the job card
                   JobCard(job: app.job),
                   // status badge
                   Positioned(
                    top: 10,
                    right: 15,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        app.status,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
