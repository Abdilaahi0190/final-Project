import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller-ada loogu talagalay meelaha banaan (Fields)
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  // Is-beddelka muuqashada password-ka
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
                      // Cinwaanka (Title)
                      Text(
                        'Create Account',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF764ba2),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Ku soo biir oo bilow mustaqbalkaaga',
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
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Confirm Password Field
                      TextField(
                        controller: _confirmPasswordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Confirm Password',
                          prefixIcon: const Icon(Icons.lock_reset_outlined, color: Color(0xFF764ba2)),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Register Button
                      Obx(() => SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: _authController.isLoading.value ? null : _handleRegister,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF764ba2),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          ),
                          child: _authController.isLoading.value
                              ? const CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'REGISTER',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      )),
                      const SizedBox(height: 20),

                      // Dib ugu laabashada login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account? ", style: GoogleFonts.poppins()),
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Text(
                              'Login',
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

  // Shaqada (Function) loogu talagalay caqliga is-diiwaangelinta
  void _handleRegister() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    // Hubinta aasaasiga ah (Basic checks)
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar('Khalad', 'Fadlan buuxi dhammaan meelaha banaan', backgroundColor: Colors.red[100]);
      return;
    }

    // Hubi haddii password-yadu ay is leeyihiin
    if (password != confirmPassword) {
      Get.snackbar('Khalad', 'Password-yadu isma lahan', backgroundColor: Colors.red[100]);
      return;
    }

    // Is-diiwaangelin iyadoo la isticmaalayo controller-ka
    final error = await _authController.signup(email, password);
    if (error == null) {
      Get.snackbar('Guul', 'Akoonka waa la abuuray si guul leh!');
      Get.offAllNamed('/home');
    } else {
      Get.snackbar('Is-diiwaangelintu waa Fashilantay', error, backgroundColor: Colors.red[100]);
    }
  }
}
