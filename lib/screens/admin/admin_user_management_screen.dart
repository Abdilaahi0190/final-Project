import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/auth_controller.dart';
import '../../services/api_service.dart';

/// Admin-only screen for managing user accounts and roles
class AdminUserManagementScreen extends StatefulWidget {
  const AdminUserManagementScreen({super.key});

  @override
  State<AdminUserManagementScreen> createState() => _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState extends State<AdminUserManagementScreen> {
  final ApiService _apiService = ApiService();
  final AuthController authController = Get.find<AuthController>();
  List<dynamic> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  /// Fetches the list of all users from the backend
  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);
    try {
      final users = await _apiService.getUsers(authController.token.value);
      setState(() {
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      Get.snackbar('Error', 'Unable to fetch user list');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users Management', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF764ba2),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? Center(child: Text('No other users found', style: GoogleFonts.poppins()))
              : RefreshIndicator(
                  onRefresh: _fetchUsers,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _users.length,
                    itemBuilder: (context, index) {
                      final user = _users[index];
                      return _buildUserTile(user);
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showUserDialog(),
        backgroundColor: const Color(0xFF764ba2),
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }

  /// Individual user item with edit and delete actions
  Widget _buildUserTile(dynamic user) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF667eea),
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(
          user['email'],
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          'Role: ${user['role']}',
          style: GoogleFonts.poppins(fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () => _showUserEditDialog(user),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDelete(user['_id']),
            ),
          ],
        ),
      ),
    );
  }

  /// Dialog to create a new user account
  void _showUserDialog() {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    String selectedRole = 'job_seeker';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Create New User', style: GoogleFonts.poppins()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
              TextField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedRole,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'job_seeker', child: Text('Job Seeker')),
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                ],
                onChanged: (val) => setDialogState(() => selectedRole = val!),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final userData = {
                  'email': emailController.text,
                  'password': passwordController.text,
                  'role': selectedRole,
                };
                await _apiService.createUser(authController.token.value, userData);
                if (context.mounted) Navigator.pop(context);
                _fetchUsers();
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  /// Dialog to update an existing user's information or role
  void _showUserEditDialog(dynamic user) {
    final emailController = TextEditingController(text: user['email']);
    final passwordController = TextEditingController();
    String selectedRole = user['role'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          scrollable: true,
          title: Text('Edit User Account', style: GoogleFonts.poppins()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
              TextField(
                controller: passwordController, 
                decoration: const InputDecoration(labelText: 'New Password (Leave blank to keep same)'), 
                obscureText: true
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedRole,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'job_seeker', child: Text('Job Seeker')),
                  DropdownMenuItem(value: 'admin', child: Text('Admin')),
                ],
                onChanged: (val) => setDialogState(() => selectedRole = val!),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () async {
                final userData = {
                  'email': emailController.text,
                  'role': selectedRole,
                };
                if (passwordController.text.isNotEmpty) {
                  userData['password'] = passwordController.text;
                }
                final response = await _apiService.updateUser(authController.token.value, user['_id'], userData);
                if (response.statusCode == 200) {
                  if (context.mounted) Navigator.pop(context);
                  _fetchUsers();
                  Get.snackbar('Success', 'User profile updated');
                } else {
                  Get.snackbar('Error', 'Update failed');
                }
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  /// Delete confirmation dialog for users
  void _confirmDelete(String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User?'),
        content: const Text('This will permanently remove this user account.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('No')),
          TextButton(
            onPressed: () async {
              await _apiService.deleteUser(authController.token.value, userId);
              if (context.mounted) Navigator.pop(context);
              _fetchUsers();
            },
            child: const Text('Yes, Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
