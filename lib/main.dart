 
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shaqoraadi/screens/job_seeker/my_applications_screen.dart';
import 'package:shaqoraadi/screens/profile/profile_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/job_seeker/home_screen.dart';
import 'controllers/auth_controller.dart';
import 'controllers/job_controller.dart';
import 'controllers/application_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Bilaabista dependency injection ee loogu talagalay controller-rada
  Get.put(AuthController());
  Get.put(JobController());
  Get.put(ApplicationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ShaqoRaadi App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF764ba2),
          primary: const Color(0xFF764ba2),
          secondary: Colors.white,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Gigo dhexdhexaad ah oo khafiif ah
      ),
      // Waddada bilowga ah waxaa loo dejiyay login
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/register', page: () => const RegisterScreen()),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/my-applications', page: () => const MyApplicationsScreen()),
        GetPage(name: '/profile', page: () => const ProfileScreen()),
      ],
    );
  }
}
