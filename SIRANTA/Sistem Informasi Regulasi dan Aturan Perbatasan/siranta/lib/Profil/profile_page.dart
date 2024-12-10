import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:siranta/Dashboard/home.dart';
import 'package:siranta/Login/login_screen.dart';
import 'package:siranta/Profil/edit_profil.dart';
import 'package:siranta/Profil/ganti_password.dart';
import 'package:siranta/apicon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class UserProfile {
  final String nip;
  final String nama;
  final String? fotoProfil;

  UserProfile({
    required this.nip,
    required this.nama,
    this.fotoProfil,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      nip: json['nip']?.toString() ?? '',
      nama: json['nama'] ?? '',
      fotoProfil: json['foto_profil'],
    );
  }
}

class ProfileApiService {
  static Future<UserProfile> getUserProfile(int userId) async {
    try {
      final url = '${ApiConfig.baseUrl}user-profile/$userId';
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData['status'] == 'success') {
          return UserProfile.fromJson(responseData['data']);
        }
      }
      throw Exception('Failed to load profile: Status ${response.statusCode}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<bool> updateProfilePhoto(int userId, String base64Image) async {
    try {
      final url = '${ApiConfig.baseUrl}user/editFoto/$userId';

      final response = await http
          .patch(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'foto_profil': base64Image,
          'user_id': userId.toString(),
        }),
      )
          .timeout(Duration(seconds: 30), // Tambahkan timeout
              onTimeout: () {
        throw TimeoutException('Koneksi timeout');
      });

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['status'] == true;
      }

      throw Exception(
          'Server returned: ${response.statusCode} - ${response.body}');
    } on SocketException catch (e) {
      // Tangani error koneksi jaringan
      throw Exception('Koneksi jaringan error: ${e.message}');
    } on TimeoutException catch (e) {
      // Tangani timeout
      throw Exception('Koneksi timeout: ${e.message}');
    } catch (e) {
      rethrow;
    }
  }
}

class _ProfilPageState extends State<ProfilPage> {
  UserProfile? _userProfile;
  bool _isLoading = true;
  String? _errorMessage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'User ID not found in storage';
        });
        return;
      }

      final profile = await ProfileApiService.getUserProfile(userId);
      setState(() {
        _userProfile = profile;
        _isLoading = false;
        _errorMessage = null;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load profile: $e';
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800, // Batasi ukuran gambar
        maxHeight: 800,
        imageQuality: 85, // Compress quality
      );

      if (pickedFile != null) {
        final File imageFile = File(pickedFile.path);

        await _processAndUploadImage(imageFile);
      } else {}
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mengambil gambar: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<String> _convertImageToBase64(File imageFile) async {
    try {
      List<int> imageBytes = await imageFile.readAsBytes();

      String base64String = base64Encode(imageBytes);

      return base64String;
    } catch (e) {
      throw Exception('Failed to convert image to base64: $e');
    }
  }

  Future<void> _processAndUploadImage(File imageFile) async {
    setState(() => _isLoading = true);

    try {
      final base64Image = await _convertImageToBase64(imageFile);
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId == null) {
        throw Exception('User ID not found in storage');
      }

      try {
        final success =
            await ProfileApiService.updateProfilePhoto(userId, base64Image);

        if (success) {
          await _loadUserProfile();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Foto profil berhasil diperbarui'),
                backgroundColor: Colors.green,
              ),
            );
          }
        } else {
          throw Exception('Server returned false status');
        }
      } on SocketException {
        // Tangani error koneksi khusus socket
        _showErrorSnackBar(
            'Gagal terhubung ke server. Periksa koneksi internet Anda.');
      } on TimeoutException {
        // Tangani timeout
        _showErrorSnackBar('Koneksi timeout. Silakan coba lagi.');
      } catch (e) {
        _showErrorSnackBar('Gagal memperbarui foto profil: ${e.toString()}');
      }
    } catch (e) {
      _showErrorSnackBar('Gagal memproses gambar: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorSnackBar(String message) {
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  Widget _buildProfilePhotoWithEdit() {
    return Stack(
      children: [
        CircleAvatar(
          radius: MediaQuery.of(context).size.width > 600 ? 72 : 48,
          backgroundImage: _userProfile?.fotoProfil != null
              ? MemoryImage(base64Decode(_userProfile!.fotoProfil!))
              : null,
          child: _userProfile?.fotoProfil == null
              ? const Icon(Icons.person)
              : null,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => _showImageSourceDialog(),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 16,
              child: Icon(Icons.edit, color: Colors.blue[600], size: 16),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _showImageSourceDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Pilih Sumber Gambar',
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeri'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Kamera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _buildOption({
    required IconData icon,
    required String text,
    required Color textColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 16.0,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 24.0,
            ),
            const SizedBox(width: 16.0),
            Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(255, 15, 101, 172), // Dark background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            );
          },
        ),
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
      ),
      body: _errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.white),
                  ),
                  ElevatedButton(
                    onPressed: _loadUserProfile,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.cyan,
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 200,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue.shade900.withOpacity(0.7),
                                  Colors.blue.shade900.withOpacity(0.8),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 20),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.cyan.withOpacity(0.5),
                                      width: 3,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.cyan.withOpacity(0.3),
                                        spreadRadius: 5,
                                        blurRadius: 10,
                                      )
                                    ],
                                  ),
                                  child: _buildProfilePhotoWithEdit(),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  _userProfile?.nama ?? 'Loading...',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w300,
                                    letterSpacing: 1.1,
                                  ),
                                ),
                                Text(
                                  _userProfile?.nip ?? 'Loading...',
                                  style: TextStyle(
                                    color: Colors.cyan.shade200,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w200,
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Profile Options with Futuristic Design
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.cyan.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildFuturisticOption(
                              icon: Icons.edit,
                              text: 'Edit Profil',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const EditProfileForm(),
                                  ),
                                );
                              },
                            ),
                            _divider(),
                            _buildFuturisticOption(
                              icon: Icons.lock,
                              text: 'Ganti Kata Sandi',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const GantiPassword(),
                                  ),
                                );
                              },
                            ),
                            _divider(),
                            _buildFuturisticOption(
                              icon: Icons.exit_to_app,
                              text: 'Keluar',
                              textColor: Colors.red,
                              iconColor: Colors.red,
                              onTap: () async {
                                // Tampilkan dialog konfirmasi
                                final shouldLogout = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Konfirmasi Keluar'),
                                    content: const Text(
                                        'Apakah Anda yakin ingin keluar?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Batal'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text(
                                          'Keluar',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );

                                if (shouldLogout == true) {
                                  try {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    // Hapus user_id
                                    await prefs.remove('user_id');
                                    // Hapus semua data preferences jika perlu
                                    // await prefs.clear();

                                    if (!mounted) return;

                                    // Navigate to login screen and clear all routes
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                      (route) =>
                                          false, // This will remove all routes from the stack
                                    );
                                  } catch (e) {
                                    if (!mounted) return;
                                    // Show error if logout fails
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Gagal keluar. Silakan coba lagi.'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildFuturisticOption({
    required IconData icon,
    required String text,
    VoidCallback? onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? Colors.cyan.shade200,
              size: 24.0,
            ),
            const SizedBox(width: 16.0),
            Text(
              text,
              style: TextStyle(
                color: textColor ?? Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.w300,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.chevron_right,
              color: iconColor ?? Colors.cyan.shade200,
            ),
          ],
        ),
      ),
    );
  }

// Divider for options
  Widget _divider() {
    return Divider(
      color: Colors.cyan.withOpacity(0.2),
      height: 1,
      indent: 16,
      endIndent: 16,
    );
  }
}
