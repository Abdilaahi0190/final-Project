// Shaashadda Soo Gelitaanka (Login)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controller-ada loogu talagalay in laga soo qaado qoraalka meelaha banaan
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  // Qari ama tusi password-ka
  bool _obscurePassword = true;

  // Soo qaadashada auth controller-ka
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Qurxinta midabka asalka ah (Background gradient)
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(30.0),
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // title text
                      Text(
                        'Welcome Back',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF764ba2),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Login to your account',
                        style: GoogleFonts.poppins(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 40),

                      // Email Field
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFF764ba2)),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password Field
                      TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF764ba2)),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              // toggle password visibility
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Login Button
                      Obx(() => SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _authController.isLoading.value ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF764ba2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: _authController.isLoading.value
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'LOGIN',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      )),
                      const SizedBox(height: 20),

                      // go to register page
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account? ", style: GoogleFonts.poppins()),
                          GestureDetector(
                            onTap: () => Get.toNamed('/register'),
                            child: Text(
                              'Register',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF764ba2),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Shaqada (Function) gacanta ku haysa soo gelitaanka
  void _handleLogin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Hubi haddii meelaha banaan ay wax ka maqan yihiin
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Khalad', 'Fadlan buuxi dhammaan meelaha banaan', backgroundColor: Colors.red[100]);
      return;
    }

    // Ka wac login controller-ka
    final error = await _authController.login(email, password);
    if (error == null) {
      // Guul!
      Get.offAllNamed('/home');
    } else {
      // Tus farriinta khaladka
      Get.snackbar('Soo Gelitaanku waa Fashilmay', error, backgroundColor: Colors.red[100]);
    }
  }
}
