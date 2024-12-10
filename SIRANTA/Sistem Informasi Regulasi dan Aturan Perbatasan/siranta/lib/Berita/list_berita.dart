import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:siranta/Berita/detail_berita.dart';
import 'package:siranta/apicon.dart';

class ListBerita extends StatefulWidget {
  const ListBerita({super.key});

  @override
  State<ListBerita> createState() => _ListBeritaState();
}

class _ListBeritaState extends State<ListBerita> {
  List<dynamic> _beritaList = [];
  List<dynamic> _filteredBeritaList = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBerita();
  }

  Future<void> _fetchBerita() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}beritas'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _beritaList = json.decode(response.body);
          _filteredBeritaList = List.from(_beritaList);
          _isLoading = false;
        });
      } else {
        _handleError('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      _handleError('Error loading news: $e');
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

  void _filterBerita(String query) {
    setState(() {
      _filteredBeritaList = _beritaList
          .where((berita) => berita['judul_berita']
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  Image? _decodeImage(String? imageBase64) {
    if (imageBase64 == null || imageBase64.isEmpty) return null;

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
      return Image.memory(
        bytes,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error);
        },
      );
    } catch (e) {
      print('Error decoding image: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 228, 158),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 252, 228, 158),
        automaticallyImplyLeading: false,
        title: TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'cari...',
            hintStyle: TextStyle(color: Color.fromARGB(255, 53, 53, 53)),
            prefixIcon: Icon(Icons.search, color: Colors.blue),
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          ),
          onChanged: _filterBerita,
        ),
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    'Memuat berita...',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _filteredBeritaList.length,
              itemBuilder: (context, index) {
                final berita = _filteredBeritaList[index];
                return NewsItem(
                  id: int.tryParse(berita['berita_id'].toString()) ?? 0,
                  gambar: _decodeImage(berita['foto_berita']),
                  fotoProfil: _decodeImage(berita['foto_profil']),
                  pemosting: berita['nama'] ?? 'Tidak Diketahui',
                  judul: berita['judul_berita'] ?? '',
                  tanggal: berita['tgl_berita'] ?? '',
                );
              },
            ),
    );
  }
}

class NewsItem extends StatelessWidget {
  final Image? gambar;
  final Image? fotoProfil;
  final String pemosting;
  final String judul;
  final String tanggal;
  final int id;

  const NewsItem({
    super.key,
    this.gambar,
    this.fotoProfil,
    required this.pemosting,
    required this.judul,
    required this.tanggal,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: Color.fromARGB(255, 252, 237, 193),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with profile and name
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: fotoProfil?.image,
                        radius: 20.0,
                        child: fotoProfil == null ? const Icon(Icons.person) : null,
                      ),
                      const SizedBox(width: 12.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pemosting,
                            style: const TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                              color: Color(0xFF1068BB),
                            ),
                          ),
                          Text(
                            tanggal,
                            style: const TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 12.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  // Image (if available)
                  if (gambar != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: gambar!,
                        ),
                      ),
                    ),
                  
                  // Title
                  Text(
                    judul,
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                  
                  // Read More Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailBerita(id: id),
                          ),
                        );
                      },
                      child: const Text(
                        'Lihat Selengkapnya >',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          color: Color(0xFF1068BB),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
