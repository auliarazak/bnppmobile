import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:siranta/Pendaftaran/api_service.dart';

import 'package:siranta/Pendaftaran/email_verifikasi.dart';

class AppStyles {
  static const Color primaryBlue = Color(0xFF2196F3);
  static const String fontFamily = 'Plus Jakarta Sans';

  static const TextStyle headerStyle = TextStyle(
    color: Color(0xFF4B2A2A),
    fontSize: 24,
    fontWeight: FontWeight.bold,
    fontFamily: fontFamily,
  );

  static const TextStyle hintStyle = TextStyle(
    color: primaryBlue,
    fontSize: 14,
    fontFamily: fontFamily,
  );

  static const TextStyle labelStyle = TextStyle(
    color: primaryBlue,
    fontSize: 12,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle buttonStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
  );
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formPadding = 15.0;
  bool _isFirstState = true;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  // Controllers for first state
  final _nipController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Controllers for second state
  final _namaController = TextEditingController();
  final _phoneController = TextEditingController();
  final _alamatController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedGender;

  final List<String> _genderOptions = ['Laki-laki', 'Perempuan'];

  @override
  void dispose() {
    _nipController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _namaController.dispose();
    _phoneController.dispose();
    _alamatController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppStyles.primaryBlue,
            colorScheme:
                const ColorScheme.light(primary: AppStyles.primaryBlue),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  bool _validatePasswords() {
    return _passwordController.text == _confirmPasswordController.text;
  }

  void _handleNext() {
    if (_formKey.currentState!.validate() && _validatePasswords()) {
      setState(() {
        _isFirstState = false;
      });
    }
  }

  void _handleRegister() async {
    if (_formKey.currentState!.validate() &&
        _selectedDate != null &&
        _selectedGender != null) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final Map<String, dynamic> response = await ApiService.register(
          context: context,
          nip: _nipController.text,
          email: _emailController.text,
          password: _passwordController.text,
          nama: _namaController.text,
          jenisKelamin: _selectedGender!,
          tglLahir: _selectedDate!,
          noTelp: _phoneController.text,
          alamat: _alamatController.text,
        );

        if (response.containsKey('user_id') && mounted) {
          final userId = response['user_id'].toString();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => VerifikasiEmail(
                email: _emailController.text,
                userId: userId,
              ),
            ),
          );
        } else {
          throw Exception('User ID tidak ditemukan dalam response');
        }
      } catch (e) {
        setState(() {
          _errorMessage = e.toString();
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Add this widget to show error message
  Widget _buildErrorMessage() {
    if (_errorMessage == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        _errorMessage!,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 14,
          fontFamily: AppStyles.fontFamily,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // Modify your button widget
  Widget _buildButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: AppStyles.primaryBlue,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
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
            : Text(text, style: AppStyles.buttonStyle),
      ),
    );
  }

  Widget _buildFirstStateForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AnimatedTextField(
            controller: _nipController,
            labelText: 'NIP',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'NIP tidak boleh kosong';
              }
              return null;
            },
          ),
          SizedBox(height: _formPadding),
          AnimatedTextField(
            controller: _emailController,
            labelText: 'Email',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email tidak boleh kosong';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
                return 'Email tidak valid';
              }
              return null;
            },
          ),
          SizedBox(height: _formPadding),
          AnimatedTextField(
            controller: _passwordController,
            labelText: 'Password',
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password tidak boleh kosong';
              }
              return null;
            },
          ),
          SizedBox(height: _formPadding),
          AnimatedTextField(
            controller: _confirmPasswordController,
            labelText: 'Konfirmasi Password',
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Konfirmasi password tidak boleh kosong';
              }
              if (value != _passwordController.text) {
                return 'Password tidak sama';
              }
              return null;
            },
          ),
          SizedBox(height: _formPadding * 2),
          _buildButton('Berikutnya', _handleNext),
        ],
      ),
    );
  }

  Widget _buildSecondStateForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          AnimatedTextField(
            controller: _namaController,
            labelText: 'Nama',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nama tidak boleh kosong';
              }
              return null;
            },
          ),
          SizedBox(height: _formPadding),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: AppStyles.primaryBlue, width: 2),
              borderRadius: BorderRadius.circular(5),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                value: _selectedGender,
                hint: const Text('Pilih Jenis Kelamin',
                    style: AppStyles.hintStyle),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jenis kelamin harus dipilih';
                  }
                  return null;
                },
                items: _genderOptions.map((String gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: _formPadding),
          InkWell(
            onTap: () => _selectDate(context),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: AppStyles.primaryBlue, width: 2),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedDate == null
                        ? 'Pilih Tanggal Lahir'
                        : '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
                    style: _selectedDate == null
                        ? AppStyles.hintStyle
                        : const TextStyle(
                            fontFamily: AppStyles.fontFamily,
                            color: Colors.black87,
                          ),
                  ),
                  const Icon(Icons.calendar_today,
                      color: AppStyles.primaryBlue),
                ],
              ),
            ),
          ),
          SizedBox(height: _formPadding),
          AnimatedTextField(
            controller: _phoneController,
            labelText: 'Nomor Telepon',
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Nomor telepon tidak boleh kosong';
              }
              return null;
            },
          ),
          SizedBox(height: _formPadding),
          AnimatedTextField(
            controller: _alamatController,
            labelText: 'Alamat',
            maxLines: 3,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Alamat tidak boleh kosong';
              }
              return null;
            },
          ),
          SizedBox(height: _formPadding * 2),
          _buildButton('Daftar', _handleRegister),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppStyles.primaryBlue,
              ),
              onPressed: () {
                if (!_isFirstState) {
                  setState(() {
                    _isFirstState = true;
                  });
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 60,
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        children: [
                          const Text('Daftar', style: AppStyles.headerStyle),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 10,
                              bottom: _formPadding,
                            ),
                            child: Text(
                              _isFirstState
                                  ? 'Silahkan daftar sebelum melakukan login'
                                  : 'Lengkapi data diri Anda',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontFamily: AppStyles.fontFamily,
                              ),
                            ),
                          ),
                        ],
                      ),
                      _isFirstState
                          ? _buildFirstStateForm()
                          : _buildSecondStateForm(),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedTextField extends StatefulWidget {
  final String labelText;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;

  const AnimatedTextField({
    Key? key,
    required this.labelText,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  _AnimatedTextFieldState createState() => _AnimatedTextFieldState();
}

class _AnimatedTextFieldState extends State<AnimatedTextField> {
  bool _isFocused = false;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()..addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          top: _isFocused ? 0 : 20,
          left: 10,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: _isFocused ? 1 : 0,
            child: Text(widget.labelText, style: AppStyles.labelStyle),
          ),
        ),
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          obscureText: widget.obscureText,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          maxLines: widget.maxLines,
          style: const TextStyle(
            fontFamily: AppStyles.fontFamily,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: _isFocused ? '' : widget.labelText,
            hintStyle: AppStyles.hintStyle,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 10,
            ),
            border: _buildTextFieldBorder(),
            enabledBorder: _buildTextFieldBorder(),
            focusedBorder: _buildTextFieldBorder(),
            errorBorder: _buildTextFieldBorder(color: Colors.red),
            focusedErrorBorder: _buildTextFieldBorder(color: Colors.red),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _buildTextFieldBorder({Color? color}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide(
        color: color ?? AppStyles.primaryBlue,
        width: 2,
      ),
    );
  }
}
