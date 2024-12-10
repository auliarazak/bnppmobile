import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfilPerbatasanMap extends StatefulWidget {
  const ProfilPerbatasanMap({super.key});

  @override
  State<ProfilPerbatasanMap> createState() => _ProfilPerbatasanMapState();
}

class _ProfilPerbatasanMapState extends State<ProfilPerbatasanMap> {
  @override
  void initState() {
    super.initState();
    // Atur orientasi menjadi landscape saat halaman dimasuki
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  @override
  void dispose() {
    // Kembalikan orientasi ke portrait saat halaman keluar
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gambar
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/petaIndonesia.jpg'),
                fit: BoxFit.cover, // Menyesuaikan gambar dengan layar
              ),
            ),
          ),
          // Tombol back di sudut kiri atas
          Positioned(
            top: 16,
            left: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }
}