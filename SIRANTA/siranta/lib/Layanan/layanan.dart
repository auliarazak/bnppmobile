import 'package:flutter/material.dart';

class Layanan extends StatefulWidget {
  const Layanan({super.key});

  @override
  State<Layanan> createState() => _LayananState();
}

class _LayananState extends State<Layanan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1068BB), // Warna biru
        title: const Text(
          'Layanan',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans', // Menggunakan font Plus Jakarta Sans
            color: Colors.white, // Warna teks putih
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Warna icon putih
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
                  imagePath: 'assets/images/PeraturanMentri.png',
                  label: 'Layanan 1',
                  onTap: () {
                    // Aksi ketika tombol Layanan 1 ditekan
                  },
                );
              case 1:
                return _buildServiceButton(
                  imagePath: 'assets/images/Peraturan.png',
                  label: 'Layanan 2',
                  onTap: () {
                    // Aksi ketika tombol Layanan 2 ditekan
                  },
                );
              case 2:
                return _buildServiceButton(
                  imagePath: 'assets/images/Peraturan2.png',
                  label: 'Layanan 3',
                  onTap: () {
                    // Aksi ketika tombol Layanan 3 ditekan
                  },
                );
              case 3:
                return _buildServiceButton(
                  imagePath: 'assets/images/Peraturan3.png',
                  label: 'Layanan 4',
                  onTap: () {
                    // Aksi ketika tombol Layanan 4 ditekan
                  },
                );
                case 4:
                return _buildServiceButton(
                  imagePath: 'assets/images/Peraturan4.png',
                  label: 'Layanan 4',
                  onTap: () {
                    // Aksi ketika tombol Layanan 4 ditekan
                  },
                );
                case 5:
                return _buildServiceButton(
                  imagePath: 'assets/images/Peraturan5.png',
                  label: 'Layanan 4',
                  onTap: () {
                    // Aksi ketika tombol Layanan 4 ditekan
                  },
                );
                case 6:
                return _buildServiceButton(
                  imagePath: 'assets/images/PeraturanBnpp.png',
                  label: 'Layanan 4',
                  onTap: () {
                    // Aksi ketika tombol Layanan 4 ditekan
                  },
                );
              default:
                return SizedBox(); // Return empty widget if index is out of range
            }
          },
        ),
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
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    width: 60,
                    height: 60,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Color.fromARGB(255, 29, 29, 29),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
