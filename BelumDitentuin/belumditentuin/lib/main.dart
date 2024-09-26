import 'package:belumditentuin/Dashboard/dashboard.dart';
import 'package:belumditentuin/Home/home.dart';
import 'package:belumditentuin/LoginScreen/loginscreen.dart';
import 'package:belumditentuin/SplashScreen/splashscreen.dart';
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
      home: const SplashScreen(),
    );
  }
}

