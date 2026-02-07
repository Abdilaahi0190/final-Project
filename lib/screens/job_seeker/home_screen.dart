import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../admin/admin_job_management_screen.dart';
import '../admin/admin_user_management_screen.dart';
import 'all_jobs_screen.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/job_controller.dart';
import '../../widgets/job_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get controllers
    final AuthController authController = Get.find<AuthController>();
    final JobController jobController = Get.find<JobController>();

    // Get user data
    String userEmail = authController.email.value;
    String userRole = authController.role.value;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      // Navigation Drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xFF764ba2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/Job-logo.jpg',
                      height: 50,
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    userRole == 'admin' ? 'Admin Dashboard' : 'Job Seeker',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Job Seeker specific items
            if (userRole != 'admin') ...[
              ListTile(
                leading: const Icon(Icons.person_outline, color: Color(0xFF764ba2)),
                title: Text('My Profile', style: GoogleFonts.poppins()),
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed('/profile');
                },
              ),
              ListTile(
                leading: const Icon(Icons.assignment_outlined, color: Color(0xFF764ba2)),
                title: Text('My Applications', style: GoogleFonts.poppins()),
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed('/my-applications');
                },
              ),
            ],
            // Admin specific items
            if (userRole == 'admin') ...[
              ListTile(
                leading: const Icon(Icons.work_outline, color: Color(0xFF764ba2)),
                title: Text('Job Management', style: GoogleFonts.poppins()),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const AdminJobManagementScreen());
                },
              ),
              ListTile(
                leading: const Icon(Icons.people_alt_outlined, color: Color(0xFF764ba2)),
                title: Text('User Management', style: GoogleFonts.poppins()),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const AdminUserManagementScreen());
                },
              ),
            ],
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text('Logout', style: GoogleFonts.poppins(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                authController.logout();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(
          'JobFinder',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu_open, color: Color(0xFF764ba2)),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () => authController.logout(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => jobController.fetchJobs(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 10),
                decoration: const BoxDecoration(
                  color: Color(0xFF764ba2),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Good day,',
                          style: GoogleFonts.poppins(fontSize: 18, color: Colors.white70),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            userRole.toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      userEmail,
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 20),
                    // Search Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        onChanged: (value) => jobController.filterJobs(value),
                        style: GoogleFonts.poppins(color: Colors.white),
                        decoration: InputDecoration(
                          icon: const Icon(Icons.search, color: Colors.white),
                          hintText: 'Search jobs...',
                          hintStyle: GoogleFonts.poppins(color: Colors.white70),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Recent Jobs Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Recent Jobs',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.to(() => const AllJobsScreen()),
                      child: Text(
                        'See All',
                        style: GoogleFonts.poppins(color: const Color(0xFF764ba2)),
                      ),
                    ),
                  ],
                ),
              ),

              // Job List
              Obx(() {
                if (jobController.isLoading.value) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                if (jobController.jobs.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Text('No jobs available', style: GoogleFonts.poppins()),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: jobController.filteredJobs.length,
                  itemBuilder: (context, index) {
                    final job = jobController.filteredJobs[index];
                    return JobCard(job: job);
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
