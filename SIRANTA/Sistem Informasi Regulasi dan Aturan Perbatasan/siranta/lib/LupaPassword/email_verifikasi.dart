import 'package:flutter/material.dart';
import 'package:siranta/LupaPassword/ganti_sandi.dart';
import 'dart:async';
import 'package:siranta/Pendaftaran/api_service.dart';

class VerifikasiEmailForPassword extends StatefulWidget {
  final String email;
  final String userId;

  const VerifikasiEmailForPassword({
    Key? key,
    required this.email,
    required this.userId,
  }) : super(key: key);

  @override
  State<VerifikasiEmailForPassword> createState() =>
      _VerifikasiEmailForPasswordState();
}

class _VerifikasiEmailForPasswordState
    extends State<VerifikasiEmailForPassword> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  bool isResendEnabled = true;
  bool _isLoading = false;
  String? _errorMessage;
  int _timerSeconds = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < 6; i++) {
      _focusNodes[i].addListener(() {
        if (_focusNodes[i].hasFocus) {
          _controllers[i].selection = TextSelection(
            baseOffset: 0,
            extentOffset: _controllers[i].text.length,
          );
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Future<void> _verifyCode() async {
    final code = _controllers.map((c) => c.text.trim()).join();

    if (code.length != 6) {
      setState(() {
        _errorMessage = 'Kode verifikasi harus 6 digit';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ApiService.verifyResetCode(
        context: context,
        userId: widget.userId,
        verificationCode: code,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GantiSandi(userId: widget.userId),
          ),
        );
      }
    } catch (e) {
      setState(() {
        if (e.toString().contains('400')) {
          _errorMessage = 'Kode verifikasi tidak valid';
        } else {
          _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
        }
        for (var controller in _controllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildCodeInputField(int index) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
            // Ubah warna border berdasarkan error
            color: _errorMessage != null ? Colors.red : Colors.blue,
            width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 18),
        maxLength: 1,
        onChanged: (value) {
          // Reset error message saat user mulai mengetik
          if (_errorMessage != null) {
            setState(() {
              _errorMessage = null;
            });
          }

          if (value.isNotEmpty) {
            // Validasi input hanya angka
            if (!RegExp(r'^[0-9]$').hasMatch(value)) {
              _controllers[index].text = '';
              return;
            }

            // Pindah ke field berikutnya
            if (index < 5) {
              _focusNodes[index + 1].requestFocus();
            }
          } else if (index > 0) {
            // Pindah ke field sebelumnya saat menghapus
            _focusNodes[index - 1].requestFocus();
          }
        },
        decoration: const InputDecoration(
          counterText: "",
          border: InputBorder.none,
        ),
      ),
    );
  }

  void _startTimer() {
    setState(() {
      isResendEnabled = false;
      _timerSeconds = 30;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timerSeconds > 0) {
          _timerSeconds--;
        } else {
          isResendEnabled = true;
          timer.cancel();
        }
      });
    });
  }

  Future<void> _resendVerificationCode() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await ApiService.resendVerificationCode(
          context: context, userId: widget.userId);

      _startTimer();

      // Reset semua field
      for (var controller in _controllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();

      if (mounted) {
        _showSuccessMessage(
            context, 'Kode verifikasi baru telah dikirim ke email Anda');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal mengirim ulang kode: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 30),
                child: Center(
                  child: Image.asset(
                    'assets/images/emailSend.png',
                    height: 100,
                  ),
                ),
              ),
              const Text(
                "Masukkan Kode Verifikasi",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Kode Verifikasi dikirim ke ${widget.email}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => _buildCodeInputField(index),
                ),
              ),
              if (_errorMessage != null)
                Container(
                  margin: const EdgeInsets.only(top: 16),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _verifyCode,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(200, 55),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Konfirmasi Kode",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: (isResendEnabled && !_isLoading)
                        ? _resendVerificationCode
                        : null,
                    child: Text(
                      "Kirim ulang kode verifikasi",
                      style: TextStyle(
                        fontSize: 14,
                        color: isResendEnabled ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ),
                  if (!isResendEnabled)
                    Text(
                      " (${_timerSeconds}s)",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
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

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSuccessMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            color: Colors.white,
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
