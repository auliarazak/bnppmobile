import 'package:flutter/material.dart';
import 'package:siranta/Pendaftaran/api_service.dart';
import 'package:siranta/VerifikasiAkun/email_verifikasi.dart';

class EmailInput extends StatefulWidget {
  const EmailInput({super.key});

  @override
  State<EmailInput> createState() => _EmailInputState();
}

class _EmailInputState extends State<EmailInput> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _sendVerificationCode() async {
    setState(() {
      _errorMessage = null;
    });

    String email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Email tidak boleh kosong';
      });
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      setState(() {
        _errorMessage = 'Format email tidak valid';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.reVerifyEmail(
        context: context,
        email: email,
      );

      if (mounted) {
        if (response['is_verified'] == true) {
          _showSuccessMessage(context, 'Email sudah terverifikasi');
          Navigator.pop(context);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EmailVerifikasi(
                email: email,
                userId: response['user_id'], // Now this is a String
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          if (e.toString().contains('404')) {
            _errorMessage = 'Email tidak terdaftar';
          } else if (e.toString().contains('400')) {
            _errorMessage = 'Email sudah terverifikasi';
          } else {
            _errorMessage = 'Terjadi kesalahan. Silakan coba lagi nanti.';
          }
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1068BB),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Verifikasi Email',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            Image.asset(
              'assets/images/notFound.png', // Make sure to add this image
              height: 150,
            ),
            const SizedBox(height: 10),
            const Text(
              'Verifikasi Email',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Masukkan email Anda untuk menerima kode verifikasi. Kode ini diperlukan untuk memverifikasi akun Anda.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email),
                labelText: 'Email',
                errorText: _errorMessage,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Color(0xFF1068BB),
                    width: 2.0,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0xFF1068BB),
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _sendVerificationCode,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: const BorderSide(
                    color: Color(0xFF1068BB),
                  ),
                ),
                backgroundColor: const Color(0xFF1068BB),
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 55),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Kirim Kode Verifikasi'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: const Color(0xFF1068BB),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 100,
          left: 16,
          right: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}