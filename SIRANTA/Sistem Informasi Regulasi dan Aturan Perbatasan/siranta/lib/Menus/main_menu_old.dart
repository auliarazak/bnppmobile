import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siranta/Berita/Create/input_berita.dart';
import 'package:siranta/Berita/Edit/list_edit_berita.dart';
import 'package:siranta/Dashboard/home.dart';
import 'package:siranta/Paparan/Create/input_paparan.dart';
import 'package:siranta/Paparan/Edit/list_edit_paparan.dart';
import 'package:siranta/Peraturans/Edit/list_edit_peraturan.dart';
import 'package:siranta/Peraturans/Create/input_peraturan.dart';
import 'package:siranta/apicon.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with SingleTickerProviderStateMixin {
  bool isMenuOpen = false;
  bool canEdit = false;
  bool canEditAll = false;
  bool canEditBerita = false;
  int? userRole;

  late final AnimationController _animationController = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  late final Animation<double> _translateButton = Tween<double>(
    begin: -10,
    end: -10,
  ).animate(CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeInOut,
  ));

  @override
  void initState() {
    super.initState();
    _fetchUserLevel();
  }

  Future<void> _fetchUserLevel() async {
    try {
      // Get user ID from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId == null) {
        print('User ID not found');
        return;
      }

      // Make API call to check user level
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}cek-level/$userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${prefs.getString('token')}',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final userLevel = responseData['level_user'];

        setState(() {
          userRole = userLevel;
          _setUserPermissions(userLevel);
        });
      } else {
        print('Failed to fetch user level');
      }
    } catch (e) {
      print('Error fetching user level: $e');
    }
  }

  void _setUserPermissions(int? level) {
    switch (level) {
      case 1: // Super Admin - Full Access
        setState(() {
          canEdit = true;
          canEditAll = true;
          canEditBerita = true;
        });
        break;
      case 2: // Admin Berita
        setState(() {
          canEdit = true;
          canEditAll = false;
          canEditBerita = true;
        });
        break;
      case 3: // Paparan Level 1
      case 4: // Paparan Level 2
      case 5: // Paparan Level 3
        setState(() {
          canEdit = true;
          canEditAll = false;
          canEditBerita = false;
        });
        break;
      default:
        setState(() {
          canEdit = false;
          canEditAll = false;
          canEditBerita = false;
        });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
    if (isMenuOpen) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1068BB), // Warna biru
        title: const Text(
          'Main Menu',
          style: TextStyle(
            fontFamily:
                'Plus Jakarta Sans', // Menggunakan font Plus Jakarta Sans
            color: Colors.white, // Warna teks putih
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.white), // Warna icon putih
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Home()),
            ); // Kembali ke halaman sebelumnya
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10), // Padding di sekitar grid
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 kolom
            crossAxisSpacing: 10, // Spasi horizontal antar item
            mainAxisSpacing: 10, // Spasi vertikal antar item
          ),
          itemCount: 12, // Ganti sesuai jumlah tombol yang ingin ditampilkan
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return _buildServiceButton(
                  imagePath: 'assets/icons/PeraturanPresiden.png',
                  label: 'Peraturan Presiden',
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const ListPeraturanPresiden(),
                    //   ),
                    // );
                  },
                );
              case 1:
                return _buildServiceButton(
                  imagePath: 'assets/icons/PeraturanMentri.png',
                  label: 'Peraturan Mentri',
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const ListPeraturanMentri(),
                    //   ),
                    // );
                  },
                );
              case 2:
                return _buildServiceButton(
                  imagePath: 'assets/icons/Note.png',
                  label: 'Peraturan Pemerintah',
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const ListPeraturanPemerintah(),
                    //   ),
                    // );
                  },
                );
              case 3:
                return _buildServiceButton(
                  imagePath: 'assets/icons/PeraturanPalu.png',
                  label: 'Undang-Undang',
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const ListPeraturanUU(),
                    //   ),
                    // );
                  },
                );
              case 4:
                return _buildServiceButton(
                  imagePath: 'assets/icons/Bnpp.png',
                  label: 'Peraturan BNPP',
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const ListPeraturanBnpp(),
                    //   ),
                    // );
                  },
                );
              case 5:
                return _buildServiceButton(
                  imagePath: 'assets/icons/PeraturanBulu.png',
                  label: 'Naskah Kesepahaman',
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const ListPeraturanMou(),
                    //   ),
                    // );
                  },
                );
              case 6:
                return _buildServiceButton(
                  imagePath: 'assets/icons/Presentasi2.png',
                  label: 'Paparan',
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const ListPaparan(),
                    //   ),
                    // );
                  },
                );
              case 7:
                return _buildServiceButton(
                  imagePath: 'assets/icons/Berita.png',
                  label: 'Berita',
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => const ListBerita(),
                    //   ),
                    // );
                  },
                );
              case 8:
                return _buildServiceButton(
                  imagePath: 'assets/icons/Panduan.png',
                  label: 'Panduan Pengguna',
                  onTap: () {},
                );
              default:
                return const SizedBox(); // Return empty widget if index is out of range
            }
          },
        ),
      ),
      floatingActionButton: canEdit
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Edit button with role-based visibility
                if (canEdit)
                  AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, _translateButton.value * 0.25),
                        child: ScaleTransition(
                          scale: CurvedAnimation(
                            parent: _animationController,
                            curve: Curves.easeOut,
                          ),
                          child: FloatingActionButton(
                            heroTag: "btnEdit",
                            backgroundColor: Colors.yellow[600],
                            mini: true,
                            onPressed: () => _showPopupMenu(context, true),
                            child: const Icon(Icons.edit, color: Colors.black),
                          ),
                        ),
                      );
                    },
                  ),

                // Upload button with role-based visibility
                if (canEdit)
                  Column(
                    children: [
                      const SizedBox(height: 15),
                      AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _translateButton.value * 0.10),
                            child: ScaleTransition(
                              scale: CurvedAnimation(
                                parent: _animationController,
                                curve: Curves.easeOut,
                              ),
                              child: FloatingActionButton(
                                heroTag: "btnDownload",
                                backgroundColor: Colors.blue,
                                mini: true,
                                onPressed: () => _showPopupMenu(context, false),
                                child: const Icon(Icons.upload,
                                    color: Colors.white),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),

                // Menu toggle button
                FloatingActionButton(
                  heroTag: "btnMenu",
                  backgroundColor: Colors.blue,
                  onPressed: _toggleMenu,
                  child: AnimatedIcon(
                    icon: AnimatedIcons.menu_close,
                    progress: _animationController,
                  ),
                ),
              ],
            )
          : null,
    );
  }

  Widget _buildServiceButton({
    required String imagePath,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1068BB),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPopupMenu(BuildContext context, bool isEdit) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 280,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isEdit ? 'Edit' : 'Upload',
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1068BB),
                  ),
                ),
                const SizedBox(height: 20),

                // Peraturan - only for role 1 (Super Admin)
                if (userRole == 1)
                  Column(
                    children: [
                      _buildPopupButton(
                        icon: Icons.description,
                        label: 'Peraturan',
                        onTap: () {
                          Navigator.pop(context);
                          if (isEdit) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ListEditPeraturan(),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FormInputPeraturan(),
                              ),
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),

                // Berita - for role 1 and role 2
                if (userRole == 1 || userRole == 2)
                  _buildPopupButton(
                    icon: Icons.article,
                    label: 'Berita',
                    onTap: () {
                      Navigator.pop(context);
                      if (isEdit) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ListEditBerita(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const InputBerita(),
                          ),
                        );
                      }
                    },
                  ),
                const SizedBox(height: 12),

                // Paparan - for roles 1, 3, 4, and 5
                if (userRole == 1 ||
                    userRole == 3 ||
                    userRole == 4 ||
                    userRole == 5)
                  _buildPopupButton(
                    icon: Icons.present_to_all,
                    label: 'Paparan',
                    onTap: () {
                      Navigator.pop(context);
                      if (isEdit) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ListEditPaparan(),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FormInputPaparan(),
                          ),
                        );
                      }
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPopupButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF1068BB), width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF1068BB),
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1068BB),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
