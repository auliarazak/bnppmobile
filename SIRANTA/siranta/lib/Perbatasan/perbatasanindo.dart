import 'package:flutter/material.dart';

class perbatasanindo extends StatefulWidget {
  const perbatasanindo({super.key});

  @override
  State<perbatasanindo> createState() => _perbatasanindoState();
}

class _perbatasanindoState extends State<perbatasanindo> {
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
          'Perbatasan Indonesia',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,  // Center alignment
            children: [
              // Gambar peta dengan ukuran yang dapat diatur
              Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Image.asset(
                  'assets/images/petaindo.png',
                  height: 180, // Sesuaikan ukuran gambar
                  width: double.infinity, // Sesuaikan lebar gambar
                  fit: BoxFit.cover, // Atur agar gambar menyesuaikan dengan box
                ),
              ),
              // Deskripsi teks
              const Text(
                'Perbatasan Indonesia meliputi perbatasan darat dan perbatasan laut. Indonesia berbagi perbatasan laut dengan 10 negara dan perbatasan darat dengan 3 negara.',
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10),
              const Text(
                'Perbatasan Indonesia meliputi perbatasan darat dan perbatasan laut. Jumlah negara yang berbatasan dengan Indonesia sebanyak 10 negara. Indonesia berbagi perbatasan laut dengan 10 negara, yakni Malaysia, Singapura, Filipina, India, Vietnam, Thailand, Palau, Australia, Timor Leste dan Papua Nugini. Sementara perbatasan darat Indonesia terbagi dengan perbatasan darat Malaysia, Papua Nugini dan Timor Leste.',
                style: TextStyle(fontSize: 16, height: 1.5),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 30),
              // Tombol-tombol navigasi dengan ukuran yang sama dan di tengah layar
              Center(child: _buildCustomButton(context, 'Hasil Kajian')),
              const SizedBox(height: 10),
              Center(child: _buildCustomButton(context, 'Jurnal')),
              const SizedBox(height: 10),
              Center(child: _buildCustomButton(context, 'Artikel')),
              const SizedBox(height: 10),
              Center(child: _buildCustomButton(context, 'Profil PLBN')),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi untuk membuat tombol dengan ukuran yang sama dan di tengah
  Widget _buildCustomButton(BuildContext context, String text) {
    return Container(
      width: 250,  // Lebar tombol sama
      height: 60,  // Tinggi tombol sama
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // Shadow arah ke bawah
          ),
        ],
      ),
      child: OutlinedButton(
        onPressed: () {
          // Aksi ketika tombol ditekan
        },
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero, // Atur padding agar teks ada di tengah
          side: const BorderSide(color: Color(0xFF1068BB), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Center(  // Teks berada di tengah
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF1068BB),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
