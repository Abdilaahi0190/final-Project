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
    // Soo qaadashada controller-rada
    final AuthController authController = Get.find<AuthController>();
    final JobController jobController = Get.find<JobController>();

    // Soo qaadashada xogta isticmaalaha
    String userEmail = authController.email.value;
    String userRole = authController.role.value;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      // Doorashada dhinaca (Drawer)
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
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white, size: 30),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userRole == 'admin' ? 'Qaybta Maamulka' : 'Shaqo Raadiye',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            // Waxyaabaha u gaarka ah Shaqo Raadiyaha
            if (userRole != 'admin') ...[
              ListTile(
                leading: const Icon(Icons.person_outline, color: Color(0xFF764ba2)),
                title: Text('Profile-kayga', style: GoogleFonts.poppins()),
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed('/profile');
                },
              ),
              ListTile(
                leading: const Icon(Icons.assignment_outlined, color: Color(0xFF764ba2)),
                title: Text('Codsiyadayda', style: GoogleFonts.poppins()),
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed('/my-applications');
                },
              ),
            ],
            // Waxyaabaha u gaarka ah Maamulka (Admin)
            if (userRole == 'admin') ...[
              ListTile(
                leading: const Icon(Icons.work_outline, color: Color(0xFF764ba2)),
                title: Text('Maareynta Shaqooyinka', style: GoogleFonts.poppins()),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const AdminJobManagementScreen());
                },
              ),
              ListTile(
                leading: const Icon(Icons.people_alt_outlined, color: Color(0xFF764ba2)),
                title: Text('Maareynta Isticmaalayaasha', style: GoogleFonts.poppins()),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => const AdminUserManagementScreen());
                },
              ),
            ],
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text('Ka Bax', style: GoogleFonts.poppins(color: Colors.red)),
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
          'ShaqoRaadi',
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
              // Qaybta sare (Header)
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
                          'Maalin wanaagsan,',
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
                    ),
                    const SizedBox(height: 20),
                    // Meesha baaritaanka (Search Bar)
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
                          hintText: 'Raadi shaqooyin...',
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

              // Qaybta shaqooyinka ugu dambeeyay
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Shaqooyinkii u Dambeeyay',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.to(() => const AllJobsScreen()),
                      child: Text(
                        'Arag dhammaan',
                        style: GoogleFonts.poppins(color: const Color(0xFF764ba2)),
                      ),
                    ),
                  ],
                ),
              ),

              // Liiska Shaqooyinka
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
                      child: Text('Ma jiraan shaqooyin banaan', style: GoogleFonts.poppins()),
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
