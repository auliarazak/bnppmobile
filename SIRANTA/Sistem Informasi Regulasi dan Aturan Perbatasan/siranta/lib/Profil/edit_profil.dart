import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:siranta/apicon.dart';

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({Key? key}) : super(key: key);

  @override
  State<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _tglLahirController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  bool _isLoading = true;
  String? _errorMessage;

  Map<String, String> _data = {
    'nama': '',
    'jenis_kelamin': '',
    'tgl_lahir': '',
    'no_telp': '',
    'alamat': '',
  };

  final List<String> _jenisKelaminList = ['Laki-laki', 'Perempuan'];

  void _showSnackBar(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId == null) {
        setState(() {
          _errorMessage = 'User ID tidak ditemukan';
          _isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}user/getEdit/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _namaController.text = data['nama'] ?? '';
          _tglLahirController.text = data['tgl_lahir'] ?? '';
          _noTelpController.text = data['no_telp'] ?? '';
          _alamatController.text = data['alamat'] ?? '';

          _data = {
            'nama': data['nama'] ?? '',
            'jenis_kelamin': data['jenis_kelamin'] ?? '',
            'tgl_lahir': data['tgl_lahir'] ?? '',
            'no_telp': data['no_telp'] ?? '',
            'alamat': data['alamat'] ?? '',
          };
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Gagal memuat data pengguna';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
        _isLoading = false;
      });
      print('Error loading user data: ${e.toString()}');
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isLoading = true);

      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId == null) {
        throw Exception('User ID tidak ditemukan');
      }

      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}user/editUser/$userId'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(_data),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['status'] == true) {
        if (mounted) {
          _showSnackBar(context, 'Profil berhasil diperbarui');
          Navigator.pop(context);
        }
      } else {
        throw Exception(responseData['message'] ?? 'Gagal memperbarui profil');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar(context, 'Error: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF1068BB),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 64,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadUserData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1068BB),
                ),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1068BB)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profil',
          style: TextStyle(
            color: Color(0xFF1068BB),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputField(
                label: 'Nama Lengkap',
                controller: _namaController,
                icon: Icons.person,
                onChanged: (value) {
                  setState(() {
                    _data['nama'] = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildDropdownField(),
              const SizedBox(height: 16),
              _buildDatePickerField(),
              const SizedBox(height: 16),
              _buildInputField(
                label: 'Nomor Telepon',
                controller: _noTelpController,
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  setState(() {
                    _data['no_telp'] = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              _buildInputField(
                label: 'Alamat',
                controller: _alamatController,
                icon: Icons.location_on,
                maxLines: 4,
                onChanged: (value) {
                  setState(() {
                    _data['alamat'] = value;
                  });
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1068BB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Simpan Perubahan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required Function(String) onChanged,
    IconData? icon,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF1068BB)),
        labelStyle: const TextStyle(color: Color(0xFF1068BB)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB0C5DA)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB0C5DA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1068BB), width: 2),
        ),
      ),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label harus diisi';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _data['jenis_kelamin']!.isEmpty ? null : _data['jenis_kelamin'],
      decoration: InputDecoration(
        labelText: 'Jenis Kelamin',
        prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF1068BB)),
        labelStyle: const TextStyle(color: Color(0xFF1068BB)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB0C5DA)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFB0C5DA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF1068BB), width: 2),
        ),
      ),
      items: _jenisKelaminList
          .map((String item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              ))
          .toList(),
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _data['jenis_kelamin'] = newValue;
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Jenis kelamin harus dipilih';
        }
        return null;
      },
    );
  }

  Widget _buildDatePickerField() {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: _data['tgl_lahir']!.isNotEmpty
              ? DateTime.parse(_data['tgl_lahir']!)
              : DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFF1068BB),
                  onPrimary: Colors.white,
                ),
                dialogBackgroundColor: Colors.white,
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          setState(() {
            _tglLahirController.text = formattedDate;
            _data['tgl_lahir'] = formattedDate;
          });
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: _tglLahirController,
          decoration: InputDecoration(
            labelText: 'Tanggal Lahir',
            prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFF1068BB)),
            labelStyle: const TextStyle(color: Color(0xFF1068BB)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFB0C5DA)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFB0C5DA)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF1068BB), width: 2),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Tanggal lahir harus diisi';
            }
            return null;
          },
        ),
      ),
    );
  }
}