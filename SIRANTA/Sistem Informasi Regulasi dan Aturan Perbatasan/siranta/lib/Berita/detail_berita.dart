import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:siranta/apicon.dart';

class DetailBerita extends StatefulWidget {
  final int id;

  const DetailBerita({Key? key, required this.id}) : super(key: key);

  @override
  State<DetailBerita> createState() => _DetailBeritaState();
}

class _DetailBeritaState extends State<DetailBerita> {
  bool _isLoading = true;
  String imageBase64 = '';
  String judul = '';
  String deskripsi = '';
  String tanggal = '';
  Image? _decodedImage;

  @override
  void initState() {
    super.initState();
    _fetchBeritaDetail();
  }

  Future<void> _fetchBeritaDetail() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}detailBeritas/${widget.id}'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          imageBase64 = data['foto_berita'] ?? '';
          judul = data['judul_berita'] ?? '';
          deskripsi = data['deskripsi_berita'] ?? '';
          tanggal = data['tgl_berita'] ?? '';
          _decodeImage();
          _isLoading = false;
        });
      } else {
        _handleError('Failed to load news detail: ${response.statusCode}');
      }
    } catch (e) {
      _handleError('Error loading news detail: $e');
    }
  }

  void _handleError(String message) {
    setState(() {
      _isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _decodeImage() {
    if (imageBase64.isNotEmpty) {
      try {
        String cleanBase64 = imageBase64.trim();

        if (cleanBase64.contains(';base64,')) {
          cleanBase64 = cleanBase64.split(';base64,')[1];
        }

        cleanBase64 = cleanBase64.replaceAll(RegExp(r'\s+'), '');

        int padLength = 4 - (cleanBase64.length % 4);
        if (padLength < 4) {
          cleanBase64 += '=' * padLength;
        }

        final bytes = base64Decode(cleanBase64);
        _decodedImage = Image.memory(
          bytes,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.error);
          },
        );
      } catch (e) {
        print('Error decoding image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 3,
                        width: double.infinity,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            _decodedImage ?? const Icon(Icons.image),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      const Color.fromARGB(255, 121, 121, 121)
                                          .withOpacity(0.3),
                                      const Color.fromARGB(255, 255, 255, 255)
                                          .withOpacity(0.5),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 30,
                        left: 16,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                              )
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.black),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 10, 10),
                    child: Stack(
                      alignment: Alignment.topLeft,
                      children: [
                        Text(
                          tanggal,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 48,
                            color: Colors.grey.withOpacity(0.1),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(80, 30, 0, 10),
                          child: Text(
                            judul,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                    child: Text(
                      deskripsi,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                        height: 1.6,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
