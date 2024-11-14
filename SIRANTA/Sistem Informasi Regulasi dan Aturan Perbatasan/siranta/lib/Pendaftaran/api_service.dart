import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:siranta/apicon.dart';
import 'package:flutter/material.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiService {
  static void _logError(String message, dynamic error, StackTrace? stackTrace) {
    // Untuk development
    print('Error: $message');
    print('Details: $error');
    if (stackTrace != null) print('Stack trace: $stackTrace');
  }

  static Future<Map<String, dynamic>> register({
    required BuildContext context,
    required String nip,
    required String email,
    required String password,
    required String nama,
    required String jenisKelamin,
    required DateTime tglLahir,
    required String noTelp,
    required String alamat,
  }) async {
    try {
      // Validasi format input
      if (nip.length < 5) {
        throw ApiException('NIP harus minimal 5 karakter');
      }

      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        throw ApiException('Format email tidak valid');
      }

      if (password.length < 8) {
        throw ApiException('Password harus minimal 8 karakter');
      }

      if (!RegExp(r'^[0-9]{10,13}$').hasMatch(noTelp)) {
        throw ApiException('Nomor telepon harus 10-13 digit angka');
      }

      if (nama.isEmpty || nama.length < 3) {
        throw ApiException('Nama harus minimal 3 karakter');
      }

      if (alamat.isEmpty || alamat.length < 10) {
        throw ApiException('Alamat harus minimal 10 karakter');
      }

      // Format tanggal ke yyyy-MM-dd
      final formattedDate =
          "${tglLahir.year}-${tglLahir.month.toString().padLeft(2, '0')}-${tglLahir.day.toString().padLeft(2, '0')}";

      // Buat payload request
      final Map<String, dynamic> requestBody = {
        'nip': nip.trim(),
        'email': email.trim().toLowerCase(),
        'password': password,
        'nama': nama.trim(),
        'jenis_kelamin': jenisKelamin,
        'tgl_lahir': formattedDate,
        'no_telp': noTelp.trim(),
        'alamat': alamat.trim(),
      };

      // Log request untuk debugging
      print('Request URL: ${ApiConfig.baseUrl}register');
      print('Request body: ${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      // Log response untuk debugging
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Cek apakah response body kosong
      if (response.body.isEmpty) {
        throw ApiException('Server mengembalikan response kosong');
      }

      Map<String, dynamic> responseData;
      try {
        responseData = jsonDecode(response.body) as Map<String, dynamic>;
      } catch (e) {
        _logError('Gagal parsing response JSON', e, StackTrace.current);
        throw ApiException(
            'Format response dari server tidak valid: ${response.body}');
      }

      if (response.statusCode == 201) {
        return responseData;
      } else {
        String errorMessage;

        switch (response.statusCode) {
          case 400:
            if (responseData.containsKey('errors') &&
                responseData['errors'] != null) {
              if (responseData['errors'] is Map) {
                final errors = responseData['errors'] as Map<String, dynamic>;
                errorMessage = errors.entries
                    .map((e) => '${e.key}: ${e.value}')
                    .join('\n');
              } else {
                errorMessage = responseData['errors'].toString();
              }
            } else if (responseData.containsKey('message')) {
              errorMessage = responseData['message'];
            } else {
              errorMessage = 'Data yang dimasukkan tidak valid';
            }
            break;
          case 409:
            if (responseData.containsKey('field')) {
              if (responseData['field'] == 'email') {
                errorMessage = 'Email sudah terdaftar';
              } else if (responseData['field'] == 'nip') {
                errorMessage = 'NIP sudah terdaftar';
              } else {
                errorMessage = 'Email atau NIP sudah terdaftar';
              }
            } else {
              errorMessage =
                  responseData['message'] ?? 'Email atau NIP sudah terdaftar';
            }
            break;
          case 422:
            errorMessage =
                responseData['message'] ?? 'Format data tidak sesuai';
            break;
          case 500:
            errorMessage = 'Terjadi kesalahan pada server';
            break;
          default:
            errorMessage = responseData['message'] ?? 'Registrasi gagal';
        }

        _logError('Registration failed', errorMessage, StackTrace.current);
        showErrorDialog(context, errorMessage);
        throw ApiException(errorMessage, statusCode: response.statusCode);
      }
    } on FormatException catch (e) {
      _logError('Format Exception', e, StackTrace.current);
      const errorMessage =
          'Format data tidak valid, pastikan semua field diisi dengan benar';
      showErrorDialog(context, errorMessage);
      throw ApiException(errorMessage);
    } on http.ClientException catch (e) {
      _logError('Client Exception', e, StackTrace.current);
      const errorMessage =
          'Tidak dapat terhubung ke server. Periksa koneksi internet Anda';
      showErrorDialog(context, errorMessage);
      throw ApiException(errorMessage);
    } catch (e, stackTrace) {
      _logError('Unexpected error', e, stackTrace);
      final errorMessage = e is ApiException
          ? e.toString()
          : 'Terjadi kesalahan: ${e.toString()}';
      showErrorDialog(context, errorMessage);
      throw ApiException(errorMessage);
    }
  }

// Modifikasi showErrorDialog untuk menambahkan tombol copy error
  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 8),
            const Text(
              'Error',
              style: TextStyle(
                color: Colors.red,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              child: Text(
                message,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              icon: const Icon(Icons.copy, size: 16),
              label: const Text('Copy Error'),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: message));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error message copied to clipboard'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(
                color: Color(0xFF2196F3),
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future<Map<String, dynamic>> verifyEmail({
    required BuildContext context,
    required String userId,
    required String verificationCode,
  }) async {
    try {
      // Validate inputs before making request
      if (userId.isEmpty || userId == 'true' || userId == 'false') {
        throw ApiException('User ID tidak valid');
      }

      if (verificationCode.isEmpty || verificationCode.length != 6) {
        throw ApiException('Kode verifikasi harus 6 digit');
      }

      // Log request untuk debugging
      debugPrint('Sending verification request:');
      debugPrint('userId: $userId');
      debugPrint('code: $verificationCode');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}verify-email'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode({
          'user_id': userId.trim(),
          'kode_verifikasi': verificationCode.trim(),
        }),
      );

      // Log response untuk debugging
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.body.isEmpty) {
        throw ApiException('Server mengembalikan response kosong');
      }

      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return responseData;
      } else {
        String errorMessage;
        
        switch (response.statusCode) {
          case 400:
            errorMessage = responseData['message'] ?? 'Kode verifikasi tidak valid';
            break;
          case 404:
            errorMessage = 'User tidak ditemukan';
            break;
          case 422:
            errorMessage = responseData['message'] ?? 'Data tidak valid';
            break;
          default:
            errorMessage = responseData['message'] ?? 'Verifikasi gagal';
        }

        throw ApiException(errorMessage, statusCode: response.statusCode);
      }
    } on FormatException catch (e) {
      debugPrint('Format Exception: $e');
      throw ApiException('Format data tidak valid');
    } on http.ClientException catch (e) {
      debugPrint('Client Exception: $e');
      throw ApiException('Tidak dapat terhubung ke server. Periksa koneksi internet Anda');
    } catch (e) {
      debugPrint('Verification error: $e');
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException('Terjadi kesalahan: ${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>> resendVerificationCode({
    required BuildContext context,
    required String userId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}register/resend'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        String errorMessage = 'Gagal mengirim ulang kode verifikasi';

        if (responseData['message'] != null) {
          errorMessage = responseData['message'];
        } else if (response.statusCode == 404) {
          errorMessage = 'User ID tidak ditemukan';
        } else if (response.statusCode == 429) {
          errorMessage = 'Terlalu banyak permintaan. Silakan coba lagi nanti';
        }

        showErrorDialog(context, errorMessage);
        throw ApiException(errorMessage, statusCode: response.statusCode);
      }
    } on FormatException {
      const errorMessage = 'Format data tidak valid';
      showErrorDialog(context, errorMessage);
      throw ApiException(errorMessage);
    } on http.ClientException {
      const errorMessage =
          'Tidak dapat terhubung ke server. Periksa koneksi internet Anda';
      showErrorDialog(context, errorMessage);
      throw ApiException(errorMessage);
    } catch (e) {
      final errorMessage = 'Terjadi kesalahan: ${e.toString()}';
      showErrorDialog(context, errorMessage);
      throw ApiException(errorMessage);
    }
  }
}
