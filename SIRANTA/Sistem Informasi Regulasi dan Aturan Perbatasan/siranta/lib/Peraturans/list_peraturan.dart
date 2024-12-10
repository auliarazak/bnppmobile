import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:siranta/Peraturans/detail_peraturan.dart';
import 'package:siranta/apicon.dart';

class ListPeraturan extends StatefulWidget {
  final String selectedTab;
  final String menuType;
  const ListPeraturan({super.key, required this.selectedTab, required this.menuType});

  @override
  State<ListPeraturan> createState() => _ListPeraturanState();
}

class _ListPeraturanState extends State<ListPeraturan> {
  final TextEditingController _searchController = TextEditingController();

  List _peraturanList = [];
  List _filteredPeraturanList = [];
  bool _isLoading = true;
  String _errorMessage = '';

  final Map<String, String> _apiEndpoints = {
    'UU': 'peraturan-uu',
    'PERPRES': 'peraturan-presiden',
    'INPRES': 'instruksi-presiden',
    'PP': 'peraturan-pemerintah',
    'PERMEN': 'peraturan-mentri',
    'PBNPP': 'peraturan-bnpp',
    'PKBNPP': 'peraturan-kbnpp',
    'PERDA': 'peraturan-daerah',
    'PB' : 'peraturan-biro',
    'MoU' : 'peraturan-mou',
    'LAIN' : 'peraturan-lain'
  };

  // Fetch data from API
  Future<void> fetchPeraturan() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      // Pilih endpoint berdasarkan menu type dan tab yang dipilih
      String endpoint = _apiEndpoints[widget.selectedTab] ?? '';
      
      if (endpoint.isEmpty) {
        setState(() {
          _errorMessage = 'Endpoint tidak ditemukan untuk tab ${widget.selectedTab}';
          _isLoading = false;
        });
        return;
      }

      final response = await http.get(Uri.parse(
          '${ApiConfig.baseUrl}$endpoint'));
      
      if (response.statusCode == 200) {
        setState(() {
          _peraturanList = json.decode(response.body);
          
          // Filter berdasarkan tab atau menu type jika perlu
          _filteredPeraturanList = _peraturanList;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Gagal mengambil data. Status kode: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Terjadi kesalahan';
        _isLoading = false;
      });
    }
  }


  @override
  void initState() {
    super.initState();
    fetchPeraturan();
    _searchController.addListener(_performSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      if (query.isEmpty) {
        _filteredPeraturanList = _peraturanList;
      } else {
        _filteredPeraturanList = _peraturanList.where((peraturan) {
          final title = peraturan['judul_peraturan']?.toLowerCase() ?? '';
          final nomor = peraturan['nomor_peraturan']?.toLowerCase() ?? '';
          final tahun = peraturan['tahun_peraturan']?.toLowerCase() ?? '';
          return title.contains(query) ||
              nomor.contains(query) ||
              tahun.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 252, 249, 243),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'cari...',
                hintStyle: TextStyle(
                    color: Color.fromARGB(255, 214, 214, 214)),
                prefixIcon: Icon(Icons.search, color: Colors.blue),
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              ),
            ),
          ),
          Expanded(
            child: _isLoading 
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text(
                        'Memuat data...',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Plus Jakarta Sans',
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              : _errorMessage.isNotEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 60,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: fetchPeraturan,
                          child: const Text('Coba Lagi'),
                        ),
                      ],
                    ),
                  )
                : _filteredPeraturanList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/NotFound.png',
                            height: 140,
                          ),
                          const Text(
                            'Data tidak ditemukan',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              fontFamily: 'Plus Jakarta Sans',
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredPeraturanList.length,
                      itemBuilder: (context, index) {
                        final peraturan = _filteredPeraturanList[index];
                        return _buildPeraturanCard(
                          peraturan['judul_peraturan'] ?? 'Judul tidak tersedia',
                          peraturan['abstrak'] ?? 'Abstrak tidak tersedia',
                          peraturan['singkatan_jenis'] ?? 'Jenis tidak tersedia',
                          peraturan['peraturan_id'] ?? 0,
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeraturanCard(String title, String abstrak,
      String singkatanJenis, int peraturanId) {
    return Card(
      color: Color.fromARGB(255, 255, 254, 252),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.4),
                borderRadius: BorderRadius.circular(10.0),
              ),
              padding: const EdgeInsets.all(8.0),
              child: Text(
                singkatanJenis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 25, 126, 209),
                ),
              ),
            ),
            const Divider(color: Color.fromARGB(109, 63, 58, 58), thickness: 1),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.picture_as_pdf,
                  color: Colors.blue,
                  size: 40,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text(abstrak),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(color: Color.fromARGB(109, 63, 58, 58), thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailPeraturanUU(peraturanId: peraturanId),
                      ),
                    );
                  },
                  icon: const Icon(Icons.remove_red_eye),
                  label: const Text('Lihat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
