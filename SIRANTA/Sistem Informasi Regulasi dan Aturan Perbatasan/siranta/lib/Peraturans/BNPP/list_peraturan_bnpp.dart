import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:siranta/Peraturans/BNPP/detail_peraturan_bnpp.dart';
import 'package:siranta/apicon.dart';

class ListPeraturanBnpp extends StatefulWidget {
  const ListPeraturanBnpp({super.key});

  @override
  State<ListPeraturanBnpp> createState() => _ListPeraturanBnppState();
}

class _ListPeraturanBnppState extends State<ListPeraturanBnpp> {
  final TextEditingController _searchController = TextEditingController();

  List _peraturanList = [];
  List _filteredPeraturanList = [];
  bool _isLoading = true;

  // Fetch data from API
  Future<void> fetchPeraturan() async {
    setState(() {
      _isLoading = true; // Set loading to true when starting fetch
    });
    
    try {
      final response = await http.get(Uri.parse(
          '${ApiConfig.baseUrl}peraturan-bnpp'));
      if (response.statusCode == 200) {
        setState(() {
          _peraturanList = json.decode(response.body);
          _filteredPeraturanList = _peraturanList;
          _isLoading = false; // Set loading to false when data is received
        });
      } else {
        setState(() {
          _isLoading = false; // Set loading to false even if there's an error
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false; // Set loading to false if there's an exception
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
      appBar: AppBar(
        backgroundColor: const Color(0xFF1068BB),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Peraturan BNPP',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
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
              ],
            ),
            const SizedBox(height: 10),
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
                : _filteredPeraturanList.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/NotFound.png',
                            height: 150,
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
      ),
    );
  }

  Widget _buildPeraturanCard(String title, String abstrak,
      String singkatanJenis, int peraturanId) {
    return Card(
      color: Colors.white,
      elevation: 1,
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
            const SizedBox(height: 10),
            const Divider(color: Color.fromARGB(109, 63, 58, 58), thickness: 1),
            const SizedBox(height: 10),
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
            const SizedBox(height: 20),
            const Divider(color: Color.fromARGB(109, 63, 58, 58), thickness: 1),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailPeraturanBnpp(peraturanId: peraturanId),
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