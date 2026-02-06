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
    // Getting Auth and Job controllers
    final AuthController authController = Get.find<AuthController>();
    final JobController jobController = Get.find<JobController>();

    final userEmail = authController.email.value.isNotEmpty
        ? authController.email.value
        : 'User';
    final userRole = authController.role.value;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      drawer: authController.role.value == 'admin'
          ? _buildAdminDrawer(context)
          : null,
      appBar: AppBar(
        title: Text(
          'Job Portal App',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        actions: [
          if (authController.role.value == 'admin')
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
              // Top welcome section
              _buildHeader(userEmail, userRole),

              const SizedBox(height: 24),

              // Jobs title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Latest Jobs',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () => Get.to(() => const AllJobsScreen()),
                      child: Text(
                        'See all',
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF764ba2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Jobs list
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
                      child: Text(
                        'No jobs available',
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: jobController.jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobController.jobs[index];
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

  Widget _buildAdminDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF764ba2), // Solid Purple
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white24,
                  child: Icon(
                    Icons.admin_panel_settings,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Admin Panel',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.work_outline, color: Color(0xFF764ba2)),
            title: Text('Manage Jobs', style: GoogleFonts.poppins()),
            onTap: () {
              Navigator.pop(context);
              Get.to(() => const AdminJobManagementScreen());
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.people_alt_outlined,
              color: Color(0xFF764ba2),
            ),
            title: Text(
              'Manage Users',
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.pop(context);
              Get.to(() => const AdminUserManagementScreen());
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              'Logout',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
              Get.find<AuthController>().logout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String email, String role) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24, top: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF764ba2), // Solid Purple
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
              Expanded(
                child: Text(
                  'Good day,',
                  style: GoogleFonts.poppins(fontSize: 18, color: Colors.white70),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  role.toUpperCase(),
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
            email,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  'Search jobs...',
                  style: GoogleFonts.poppins(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
