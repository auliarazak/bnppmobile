import 'package:flutter/material.dart';

class TesPage extends StatefulWidget {
  const TesPage({super.key});

  @override
  State<TesPage> createState() => _TesPageState();
}

class _TesPageState extends State<TesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset("assets/images/Logo.png", scale: 1.5,),
      ),
    );
  }
}