import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siranta/Dashboard/home.dart';
import 'package:siranta/LupaPassword/lupa_sandi.dart';
import 'package:siranta/Pendaftaran/registration_screen.dart';
import 'package:siranta/VerifikasiAkun/email_input.dart';
import 'package:siranta/apicon.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isEmailValid = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userData['user_id']);
  }

  Future<void> _login() async {
    final String email = _emailController.text;
    final String password = _passwordController.text;

    // Validasi format email
    if (!_isValidEmail(email)) {
      setState(() {
        _isEmailValid = false;
      });
      return;
    }

    // API endpoint for login
    const String apiUrl = '${ApiConfig.baseUrl}login';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData.containsKey('user') &&
            responseData['user']['user_id'] != null) {
          // Simpan data user
          await _saveUserData(responseData['user']);

          // Navigasi ke halaman home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
        } else {
          _showErrorDialog('Data pengguna tidak lengkap');
        }
      } else if (response.statusCode == 401) {
        // Handle berbagai jenis error 401
        _showErrorDialog(
            responseData['message'] ?? 'Terjadi kesalahan saat login');
      } else {
        _showErrorDialog(
            'Terjadi kesalahan pada server. Silakan coba lagi nanti.');
      }
    } catch (error) {
      print('Error logging in: $error');
      _showErrorDialog(
          'Terjadi kesalahan koneksi. Periksa koneksi internet Anda.');
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  void _showErrorDialog(String message, [String? title]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Tentukan icon dan warna berdasarkan jenis pesan
        IconData icon;
        Color iconColor;
        String dialogTitle;

        // Logika untuk menentukan tampilan berdasarkan pesan error
        if (message.toLowerCase().contains('verifikasi')) {
          icon = Icons.mail_outline;
          iconColor = Colors.orange;
          dialogTitle = 'Email Belum Terverifikasi';
        } else if (message.toLowerCase().contains('salah')) {
          icon = Icons.error_outline;
          iconColor = Colors.red;
          dialogTitle = 'Login Gagal';
        } else {
          icon = Icons.warning_amber_rounded;
          iconColor = Colors.red;
          dialogTitle = 'Error';
        }

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          content: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: iconColor,
                  size: 50,
                ),
                const SizedBox(height: 15),
                Text(
                  dialogTitle,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          elevation: 10,
          shadowColor: Colors.black.withOpacity(0.5),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade50,
                  Colors.blue.shade100,
                ],
              ),
            ),
            child: Stack(
              children: [
                // Background Pattern
                Positioned(
                  top: -50,
                  left: -50,
                  child: Opacity(
                    opacity: 0.1,
                    child: Image.asset(
                      'assets/images/bnpplogo.png',
                      width: 250,
                      height: 250,
                    ),
                  ),
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated Title
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        'Selamat Datang \n di Siranta',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 17, 48, 85),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Email Input
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade100,
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              )
                            ],
                          ),
                          child: TextField(
                            controller: _emailController,
                            onChanged: (value) {
                              setState(() {
                                _isEmailValid = _isValidEmail(value);
                              });
                            },
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                                color: _isEmailValid ? Colors.blue : Colors.red,
                              ),
                              hintText: 'Email',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(15),
                              errorText: _isEmailValid ? null : 'Format email tidak valid',
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Password Input
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade100,
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              )
                            ],
                          ),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.blue,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible 
                                    ? Icons.visibility 
                                    : Icons.visibility_off,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              hintText: 'Password',
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(15),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Links Row
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => const EmailInput())
                              ),
                              child: const Text(
                                'Verifikasi akun',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => const LupaKataSandi())
                              ),
                              child: const Text(
                                'Lupa kata sandi?',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Login Button
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          padding: const EdgeInsets.symmetric(
                            vertical: 15, 
                            horizontal: 100
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Masuk',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Register Link
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: RichText(
                        text: TextSpan(
                          text: 'Belum punya akun? ',
                          style: const TextStyle(color: Colors.grey),
                          children: [
                            TextSpan(
                              text: 'Daftar',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => const RegistrationScreen())
                                ),
                            ),
                          ],
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
    );
  }
}
