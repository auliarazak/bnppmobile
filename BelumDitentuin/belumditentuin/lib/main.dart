
import 'package:belumditentuin/Dashboard/dashboard.dart';
import 'package:belumditentuin/Layanan/layanan.dart';
import 'package:belumditentuin/SplashScreen/splashscreen.dart';
import 'package:belumditentuin/tes_lihat.dart';
import 'package:belumditentuin/Profil/gantisandi.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: GantiSandi(),
    );
  }
}

