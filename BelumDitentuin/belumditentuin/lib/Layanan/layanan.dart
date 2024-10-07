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
          itemCount: 12, // Total 12 item (3 kolom x 4 baris)
          itemBuilder: (context, index) {
            return ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero, // Menghilangkan padding internal tombol
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Sudut tombol sedikit melengkung
                ),
              ),
              onPressed: () {
                // Aksi ketika tombol ditekan
              },
              child: const Text(
                'Button',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans', // Menggunakan font Plus Jakarta Sans
                  fontSize: 16,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
