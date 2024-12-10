import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siranta/Paparan/Edit/edit_paparan.dart';
import 'package:siranta/apicon.dart';


class ListEditPaparan extends StatefulWidget {
  const ListEditPaparan({super.key});

  @override
  State<ListEditPaparan> createState() => _ListEditPaparanState();
}

class _ListEditPaparanState extends State<ListEditPaparan> {
  final TextEditingController _searchController = TextEditingController();

  List _paparanList = [];
  List _filteredPaparanList = [];
  bool _isLoading = true;

  Future<void> fetchPaparan() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId == null) {
        setState(() {
          _isLoading = false;
          _paparanList = [];
          _filteredPaparanList = [];
        });
        return;
      }

      final response = await http
          .get(Uri.parse('${ApiConfig.baseUrl}paparan?user_id=$userId'));

      if (response.statusCode == 200) {
        final dynamic decodedBody = json.decode(response.body);

        List paparanList = [];
        if (decodedBody is List) {
          paparanList = decodedBody;
        } else if (decodedBody is Map) {
          paparanList = decodedBody.values.toList();
        }

        setState(() {
          _paparanList = paparanList;
          _filteredPaparanList = _paparanList;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Failed to load data. Status: ${response.statusCode}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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

  Future<void> _deletePaparan(int paparanId) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}delete-paparan/$paparanId'),
      );

      if (response.statusCode == 200) {
        // Remove the deleted item from both lists
        setState(() {
          _paparanList.removeWhere(
              (paparan) => paparan['paparan_id'] == paparanId);
          _filteredPaparanList.removeWhere(
              (paparan) => paparan['paparan_id'] == paparanId);
        });

        if (!mounted) return;
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Paparan berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        if (!mounted) return;
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Gagal menghapus paparan'),
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

  void _showDeleteConfirmation(int paparanId) {
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
            'Apakah Anda yakin ingin menghapus paparan ini?',
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
                _deletePaparan(paparanId);
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
                  : _filteredPaparanList.isEmpty
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
      ),
    );
  }

  Widget _buildPaparanCard(String judul, String deskripsi, String pembuat,
      String tag, int paparanId) {
    return Card(
      color: const Color.fromARGB(255, 255, 232, 223),
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
                            EditPaparan(paparanId: paparanId),
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
                    _showDeleteConfirmation(paparanId);
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
