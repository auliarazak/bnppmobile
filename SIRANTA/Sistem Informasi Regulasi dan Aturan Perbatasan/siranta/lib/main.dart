import 'package:flutter/material.dart';
import 'package:siranta/Dashboard/dashboard.dart';
import 'package:siranta/Dashboard/home.dart';
import 'package:siranta/Login/login_screen.dart';
import 'package:siranta/PLBN/profil_perbatasan.dart';
import 'package:siranta/Paparan/list_paparan.dart';
import 'package:siranta/Menus/mainmenu.dart';
import 'package:siranta/PengaturanData/peraturan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SIRANTA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Plus Jakarta Sans',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainMenu(),  
    );
  }
}

