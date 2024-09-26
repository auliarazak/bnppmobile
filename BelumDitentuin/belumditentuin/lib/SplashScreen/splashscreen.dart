import 'package:belumditentuin/Dashboard/dashboard.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Menambahkan delay 2 detik sebelum berpindah ke Dashboard
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const Dashboard(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0); // Pindah dari kanan
            const end = Offset.zero; // Posisi akhir
            const curve = Curves.easeInOut; // Kurva animasi

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF1068BB), // Warna background
        child: Center(
          child: Image.asset(
            'lib/images/BnppLogo.png', // Path gambar yang benar
            width: 250, // Atur lebar gambar sesuai kebutuhan
            height: 250, // Atur tinggi gambar sesuai kebutuhan
          ),
        ),
      ),
    );
  }
}
