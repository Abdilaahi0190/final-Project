import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/job_controller.dart';
import '../../models/job_model.dart';

class AdminJobManagementScreen extends StatelessWidget {
  const AdminJobManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final JobController jobController = Get.find<JobController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jobs Management',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF764ba2),
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (jobController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (jobController.jobs.isEmpty) {
          return Center(
            child: Text(
              'No jobs available',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => jobController.fetchJobs(),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: jobController.jobs.length,
            itemBuilder: (context, index) {
              final job = jobController.jobs[index];
              return _buildJobTile(context, job, jobController);
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showJobDialog(context, jobController),
        backgroundColor: const Color(0xFF764ba2),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildJobTile(
    BuildContext context,
    Job job,
    JobController controller,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: _parseColor(job.color),
          child: const Icon(Icons.work, color: Colors.white),
        ),
        title: Text(
          job.title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          job.company,
          style: GoogleFonts.poppins(fontSize: 12),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showJobDialog(context, controller, job: job),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDelete(context, controller, job.id),
            ),
          ],
        ),
      ),
    );
  }

  void _showJobDialog(
    BuildContext context,
    JobController controller, {
    Job? job,
  }) {
    final titleController = TextEditingController(text: job?.title);
    final companyController = TextEditingController(text: job?.company);
    final salaryController = TextEditingController(text: job?.salary);
    final typeController = TextEditingController(
      text: job?.type ?? 'Full-time',
    );
    final locationController = TextEditingController(text: job?.location);
    final descriptionController = TextEditingController(text: job?.description);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: Text(
          job == null ? 'Add Job' : 'Edit Job',
          style: GoogleFonts.poppins(),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: companyController,
              decoration: const InputDecoration(labelText: 'Company'),
            ),
            TextField(
              controller: salaryController,
              decoration: const InputDecoration(labelText: 'Salary'),
            ),
            TextField(
              controller: typeController,
              decoration: const InputDecoration(
                labelText: 'Type (Full-time/Contract)',
              ),
            ),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final jobData = {
                'title': titleController.text,
                'company': companyController.text,
                'salary': salaryController.text,
                'type': typeController.text,
                'location': locationController.text,
                'description': descriptionController.text,
                'logo': 'work',
                'color': job?.color ?? '0xFF764ba2',
              };

              if (job == null) {
                await controller.addJob(jobData);
              } else {
                await controller.updateJob(job.id, jobData);
              }
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
    BuildContext context,
    JobController controller,
    String jobId,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Are you sure you want to delete this job?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () async {
              await controller.deleteJob(jobId);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text(
              'Yes, Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String colorStr) {
    try {
      if (colorStr.startsWith('0xFF')) {
        return Color(int.parse(colorStr));
      } else if (colorStr.startsWith('#')) {
        return Color(int.parse(colorStr.replaceFirst('#', '0xFF')));
      }
      return const Color(0xFF764ba2);
    } catch (e) {
      return const Color(0xFF764ba2);
    }
  }
}
