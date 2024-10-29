import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; 

class GantiSandi extends StatefulWidget {
  const GantiSandi({super.key});

  @override
  State<GantiSandi> createState() => _GantiSandiState();
}

class _GantiSandiState extends State<GantiSandi> {
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
          'Ganti Kata Sandi',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(  // Tambahkan SingleChildScrollView di sini
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Gambar ilustrasi dari asset lokal
            Container(
              margin: const EdgeInsets.only(top: 30, bottom: 30),
              child: Image.asset(
                'lib/images/bnpplogo.png',
                height: 200,
              ),
            ),
            // Field kata sandi lama
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Kata Sandi Lama',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1068BB)),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFF1068BB), width: 2),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 40),
            // Field kata sandi baru
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Kata Sandi Baru',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1068BB)),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFF1068BB), width: 2),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 40),
            // Field ulangi kata sandi baru
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Ulang Kata Sandi Baru',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF1068BB)),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFF1068BB), width: 2),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 60),

            ElevatedButton(
              onPressed: () {
                // Memanggil notifikasi setelah tombol simpan ditekan
                showResetPasswordNotification(context);
              },
              child: const Text(
                'Simpan',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                backgroundColor: const Color(0xff1068BB),
                minimumSize: const Size(200, 55),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk menampilkan notifikasi setelah reset password
  void showResetPasswordNotification(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Mengganti Image.asset dengan Lottie.asset untuk animasi
              Lottie.asset(
                'lib/component/lottie/succes.json', // Path ke file Lottie
                height: 150, // Sesuaikan ukuran animasi
              ),
              const SizedBox(height: 20),
              // Pesan notifikasi
              const Text(
                'Kata sandimu berhasil di reset\nSekarang masuk dengan sandi baru',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              // Tombol Login
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Tutup dialog
                  // Tambahkan aksi untuk pergi ke halaman login
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1068BB), // Sesuaikan warna
                  padding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
