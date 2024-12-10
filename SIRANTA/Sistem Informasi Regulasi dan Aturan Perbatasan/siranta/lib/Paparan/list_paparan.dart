import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:siranta/apicon.dart';
import 'package:siranta/Paparan/detail_paparan.dart';

class ListPaparan extends StatefulWidget {
  final String selectedTab;
  final String menuType;
  const ListPaparan(
      {super.key, required this.selectedTab, required this.menuType});

  @override
  State<ListPaparan> createState() => _ListPaparanState();
}

class _ListPaparanState extends State<ListPaparan> {
  final TextEditingController _searchController = TextEditingController();

  List _paparanList = [];
  List _filteredPaparanList = [];
  bool _isLoading = true;
  String _errorMessage = '';

  final Map<String, String> _apiEndpoints = {
    'PPKA': 'paparan-ppka',
    'PBWNKP': 'paparan-pbwnkp',
    'DI': 'paparan-di',
    'FKSDLN': 'paparan-fksdln',
    'LAIN': 'paparan-lain',
    'SSP': 'paparan-ssp',
  };

  // Fetch data from API
  Future<void> fetchPaparan() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');
      // Pilih endpoint berdasarkan menu type dan tab yang dipilih
      String endpoint = _apiEndpoints[widget.selectedTab] ?? '';

      if (endpoint.isEmpty) {
        setState(() {
          _errorMessage =
              'Endpoint tidak ditemukan untuk tab ${widget.selectedTab}';
          _isLoading = false;
        });
        return;
      }

      final response = await http
          .get(Uri.parse('${ApiConfig.baseUrl}$endpoint?user_id=$userId'));

      if (response.statusCode == 200) {
        setState(() {
          // Jika response adalah map dengan key numerik, konversi ke list
          var jsonResponse = json.decode(response.body);
          _paparanList =
              jsonResponse is Map ? jsonResponse.values.toList() : jsonResponse;

          _filteredPaparanList = _paparanList;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage =
              'Gagal mengambil data. Status kode: ${response.statusCode}';
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
    fetchPaparan();
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
        _filteredPaparanList = _paparanList;
      } else {
        _filteredPaparanList = _paparanList.where((paparan) {
          final judul = paparan['judul_paparan']?.toLowerCase() ?? '';
          final deskripsi = paparan['deskripsi_paparan']?.toLowerCase() ?? '';
          final pembuat = paparan['pembuat']?.toLowerCase() ?? '';
          final tag = paparan['tag']?.toLowerCase() ?? '';
          return judul.contains(query) ||
              deskripsi.contains(query) ||
              pembuat.contains(query) ||
              tag.contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 224, 245, 255),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'cari...',
                hintStyle: TextStyle(color: Color.fromARGB(255, 214, 214, 214)),
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
                              onPressed: fetchPaparan,
                              child: const Text('Coba Lagi'),
                            ),
                          ],
                        ),
                      )
                    : _filteredPaparanList.isEmpty
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
                            itemCount: _filteredPaparanList.length,
                            itemBuilder: (context, index) {
                              final paparan = _filteredPaparanList[index];
                              return _buildPaparanCard(
                                paparan['judul_paparan'] ??
                                    'Judul tidak tersedia',
                                paparan['deskripsi_paparan'] ??
                                    'Abstrak tidak tersedia',
                                paparan['pembuat'] ?? 'Jenis tidak tersedia',
                                paparan['tag'] ?? 'Tag tidak tersedia',
                                paparan['paparan_id'] ?? 0,
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaparanCard(String judul, String deskripsi, String pembuat,
      String tag, int paparanId) {
    return Card(
      color: const Color.fromARGB(255, 241, 251, 255),
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
                tag,
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
                      Text(judul,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text(deskripsi),
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
                            DetailPaparan(paparanId: paparanId),
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
