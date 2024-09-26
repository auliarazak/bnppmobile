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
        title: Text('Layanan'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Untuk kembali ke halaman sebelumnya
          },
        ),
      ),
    );
  }
}