import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:siranta/Peraturans/Edit/edit_peraturan.dart';
import 'package:siranta/apicon.dart';

class ListEditPeraturan extends StatefulWidget {
  const ListEditPeraturan({super.key});

  @override
  State<ListEditPeraturan> createState() => _ListEditPeraturanState();
}

class _ListEditPeraturanState extends State<ListEditPeraturan> {
  final TextEditingController _searchController = TextEditingController();

  List _peraturanList = [];
  List _filteredPeraturanList = [];
  bool _isLoading = true;

  Future<void> fetchPeraturan() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response =
          await http.get(Uri.parse('${ApiConfig.baseUrl}all-peraturan'));
      if (response.statusCode == 200) {
        setState(() {
          _peraturanList = json.decode(response.body);
          _filteredPeraturanList = _peraturanList;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
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

  Future<void> _deletePeraturan(int peraturanId) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}deletePeraturan/$peraturanId'),
      );

      if (response.statusCode == 200) {
        // Remove the deleted item from both lists
        setState(() {
          _peraturanList.removeWhere(
              (peraturan) => peraturan['peraturan_id'] == peraturanId);
          _filteredPeraturanList.removeWhere(
              (peraturan) => peraturan['peraturan_id'] == peraturanId);
        });

        if (!mounted) return;
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Peraturan berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        if (!mounted) return;
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menghapus peraturan'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      // Show error message for exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDeleteConfirmation(int peraturanId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: const Text(
            'Konfirmasi Hapus',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Apakah Anda yakin ingin menghapus peraturan ini?',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
          backgroundColor: Colors.white,
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Batal',
                style: TextStyle(
                  color: Colors.grey,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deletePeraturan(peraturanId);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1068BB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: const Text(
                'Hapus',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Plus Jakarta Sans',
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 206, 191),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'cari...',
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 214, 214, 214)),
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
                              peraturan['judul_peraturan'] ??
                                  'Judul tidak tersedia',
                              peraturan['abstrak'] ?? 'Abstrak tidak tersedia',
                              peraturan['jenis_peraturan']['singkatan_jenis'] ??
                                  'Jenis tidak tersedia',
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

  Widget _buildPeraturanCard(
      String title, String abstrak, String singkatanJenis, int peraturanId) {
    return Card(
      color: const Color.fromARGB(255, 252, 225, 216),
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
                            EditPeraturan(peraturanId: peraturanId),
                      ),
                    );
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 219, 189, 19),
                    foregroundColor: const Color.fromARGB(255, 34, 34, 34),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    _showDeleteConfirmation(peraturanId);
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('Hapus'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 226, 39, 33),
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
