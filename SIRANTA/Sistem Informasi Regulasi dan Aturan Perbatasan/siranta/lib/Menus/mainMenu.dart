import 'package:flutter/material.dart';
import 'package:siranta/Peraturans/BNPP/list_peraturan_bnpp.dart';
import 'package:siranta/Peraturans/Crud/Edit/list_edit_peraturan.dart';
import 'package:siranta/Peraturans/Crud/Create/input_peraturan.dart';
import 'package:siranta/Peraturans/Mentri/list_peraturan_mentri.dart';
import 'package:siranta/Peraturans/MoU/list_peraturan_mou.dart';
import 'package:siranta/Peraturans/Pemerintah/list_peraturan_pemerintah.dart';
import 'package:siranta/Peraturans/Presiden/list_peraturan_presiden.dart';
import 'package:siranta/Peraturans/UU/list_peraturan_uu.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with SingleTickerProviderStateMixin {
  bool isMenuOpen = false;
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
            Navigator.pop(context); // Kembali ke halaman sebelumnya
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListPeraturanPresiden(),
                      ),
                    );
                  },
                );
              case 1:
                return _buildServiceButton(
                  imagePath: 'assets/icons/PeraturanMentri.png',
                  label: 'Peraturan Mentri',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListPeraturanMentri(),
                      ),
                    );
                  },
                );
              case 2:
                return _buildServiceButton(
                  imagePath: 'assets/icons/PeraturanBulu.png',
                  label: 'Peraturan Pemerintah',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListPeraturanPemerintah(),
                      ),
                    );
                  },
                );
              case 3:
                return _buildServiceButton(
                  imagePath: 'assets/icons/PeraturanPalu.png',
                  label: 'Undang-Undang',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListPeraturanUU(),
                      ),
                    );
                  },
                );
              case 4:
                return _buildServiceButton(
                  imagePath: 'assets/icons/Bnpp.png',
                  label: 'Peraturan BNPP',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListPeraturanBnpp(),
                      ),
                    );
                  },
                );
              case 5:
                return _buildServiceButton(
                  imagePath: 'assets/icons/Note.png',
                  label: 'Naskah Kesepahaman',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ListPeraturanMou(),
                      ),
                    );
                  },
                );
              case 6:
                return _buildServiceButton(
                  imagePath: 'assets/icons/Panduan.png',
                  label: 'Panduan Pengguna',
                  onTap: () {},
                );
              default:
                return SizedBox(); // Return empty widget if index is out of range
            }
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Delete Button
          // AnimatedBuilder(
          //   animation: _animationController,
          //   builder: (context, child) {
          //     return Transform.translate(
          //       offset: Offset(0, _translateButton.value * 0.4),
          //       child: ScaleTransition(
          //         scale: CurvedAnimation(
          //           parent: _animationController,
          //           curve: Curves.easeOut,
          //         ),
          //         child: FloatingActionButton(
          //           heroTag: "btnDelete",
          //           backgroundColor: Colors.red,
          //           mini: true, // Membuat FAB lebih kecil
          //           onPressed: () {},
          //           child: const Icon(Icons.delete, color: Colors.white),
          //         ),
          //       ),
          //     );
          //   },
          // ),
          // Edit Button
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ListEditPeraturan(),
                        ),
                      );
                    },
                    child: const Icon(Icons.edit, color: Colors.black),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 15,),
          // Upload Button
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FormInputPeraturan(),
                        ),
                      );
                    },
                    child: const Icon(Icons.upload, color: Colors.white),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 8), // Spacing between buttons
          // Menu Toggle Button
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
      ),
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
              style: const TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
