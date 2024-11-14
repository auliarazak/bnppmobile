import 'package:flutter/material.dart';
import 'package:siranta/Menus/mainMenu.dart';
import 'package:siranta/Pendaftaran/email_verifikasi.dart';
import 'package:siranta/Pendaftaran/registration_screen.dart';
import 'package:siranta/tesdecode.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const RegistrationScreen(),
    );
  }
}

