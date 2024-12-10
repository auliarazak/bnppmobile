import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:belumditentuin/Home/home1.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isEmailValid = true;

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
    final String apiUrl = 'https://generous-joint-ape.ngrok-free.app/api/login';

    // Send login request
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        // Pastikan response mengandung data user
        if (responseData.containsKey('user')) {
          // Simpan data user
          await _saveUserData(responseData['user']);
          
          // Navigasi ke halaman home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Selamat datang, ${responseData['user']['name']}')),
          );
        } else {
          _showErrorDialog('Data pengguna tidak ditemukan');
        }
      } else {
        // Tampilkan popup jika login gagal
        _showErrorDialog('Password atau email yang anda masukan tidak terdaftar.');
      }
    } catch (error) {
      print('Error logging in: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error logging in: ${error.toString()}')),
      );
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
  }

  void _showErrorDialog([String? message]) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.close,
                color: Colors.red,
                size: 40,
              ),
              const SizedBox(height: 20),
              Text(
                message ?? 'Password / email yang anda masukan tidak terdaftar.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
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
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Opacity(
                opacity: 0.05,
                child: Image.asset(
                  'lib/images/PeraturanBNPP.png',
                  fit: BoxFit.cover,
                  width: 400,
                  height: 400,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
                    child: Text(
                      'Selamat Datang',
                      style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 17, 48, 85)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: _isEmailValid
                              ? Colors.blue
                              : Colors.red, // Kondisi warna border
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: _isEmailValid
                                  ? Colors.blue
                                  : Colors.red, // Ikon juga mengikuti validasi
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _emailController,
                                onChanged: (value) {
                                  setState(() {
                                    _isEmailValid = _isValidEmail(
                                        value); // Panggil validasi saat input berubah
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: 'Email',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                  errorText: _isEmailValid
                                      ? null
                                      : 'Format email tidak valid',
                                ),
                                style: const TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Icon(
                              Icons.lock,
                              color: Colors.blue,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _passwordController,
                                obscureText: !_isPasswordVisible,
                                decoration: InputDecoration(
                                  hintText: 'Password',
                                  hintStyle:
                                      const TextStyle(color: Colors.grey),
                                  border: InputBorder.none,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                style: const TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(
                        'Lupa kata sandi?',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 80,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text(
                        'Masuk',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 17,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      text: 'Belum punya akun? ',
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      children: [
                        TextSpan(
                          text: 'Daftar',
                          style: const TextStyle(
                            color: Colors.blue,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // Logika navigasi ke halaman daftar
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
