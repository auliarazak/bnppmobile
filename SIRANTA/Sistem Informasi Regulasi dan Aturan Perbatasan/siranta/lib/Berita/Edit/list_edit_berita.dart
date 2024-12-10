import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:siranta/Berita/Edit/edit_berita.dart';
import 'package:siranta/Berita/detail_berita.dart';
import 'package:siranta/apicon.dart';

class ListEditBerita extends StatefulWidget {
  const ListEditBerita({super.key});

  @override
  State<ListEditBerita> createState() => _ListEditBeritaState();
}

class _ListEditBeritaState extends State<ListEditBerita> {
  List<dynamic> _beritaList = [];
  List<dynamic> _filteredBeritaList = [];
  bool _isLoading = true;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  String _sortOrder = 'terbaru';

  @override
  void initState() {
    super.initState();
    _fetchBerita();
  }

  Future<void> _fetchBerita() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}all-beritas'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _beritaList = data.map((item) {
            // Pastikan status selalu string
            item['status'] = item['status'].toString();
            return item;
          }).toList();
          _filteredBeritaList = List.from(_beritaList);
          _sortBerita();
          _isLoading = false;
        });
      } else {
        _handleError('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      _handleError('Error loading news: $e');
    }
  }

  void _sortBerita() {
    setState(() {
      if (_sortOrder == 'terbaru') {
        _filteredBeritaList.sort((a, b) => DateTime.parse(b['tgl_berita'])
            .compareTo(DateTime.parse(a['tgl_berita'])));
      } else {
        _filteredBeritaList.sort((a, b) => DateTime.parse(a['tgl_berita'])
            .compareTo(DateTime.parse(b['tgl_berita'])));
      }
    });
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
      return null;
    }
  }

  Future<void> _deleteBerita(int id) async {
    // Implement delete functionality
    // Show confirmation dialog before deleting
    bool confirm = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Konfirmasi'),
            content:
                const Text('Apakah Anda yakin ingin menghapus berita ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Hapus'),
              ),
            ],
          ),
        ) ??
        false;

    if (confirm) {
      try {
        final response = await http.delete(
          Uri.parse('${ApiConfig.baseUrl}delete-berita/$id'),
          headers: {'Accept': 'application/json'},
        );

        if (response.statusCode == 200) {
          _fetchBerita(); // Refresh the list
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Berita berhasil dihapus')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menghapus berita')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 206, 191),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 248, 206, 191),
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

                return EditableNewsItem(
                  id: int.tryParse(berita['berita_id'].toString()) ?? 0,
                  gambar: _decodeImage(berita['foto_berita']),
                  fotoProfil: _decodeImage(berita['foto_profil']),
                  pemosting: berita['nama'] ?? 'Tidak Diketahui',
                  judul: berita['judul_berita'] ?? '',
                  tanggal: berita['tgl_berita'] ?? '',
                  isActive: berita['status'].toString() == '1',
                  onDelete: () =>
                      _deleteBerita(int.parse(berita['berita_id'].toString())),
                  onEdit: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditBerita(
                            beritaId:
                                int.parse(berita['berita_id'].toString())),
                      ),
                    );
                  },
                  onToggleStatus: (bool newStatus) async {
                    try {
                      final response = await http.post(
                        Uri.parse(
                            '${ApiConfig.baseUrl}toggleStatus/${berita['berita_id']}'),
                        headers: {
                          'Accept': 'application/json',
                          'Content-Type': 'application/x-www-form-urlencoded',
                        },
                        body: {
                          'status': newStatus ? '1' : '0',
                        },
                      );

                      if (response.statusCode == 200) {
                        await _fetchBerita();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(newStatus
                                ? 'Berita berhasil diaktifkan'
                                : 'Berita berhasil dinonaktifkan'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        await _fetchBerita();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Gagal mengubah status berita'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } catch (e) {
                      await _fetchBerita();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}

class EditableNewsItem extends StatefulWidget {
  final Image? gambar;
  final Image? fotoProfil;
  final String pemosting;
  final String judul;
  final String tanggal;
  final int id;
  final bool isActive;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final Function(bool) onToggleStatus;

  const EditableNewsItem({
    super.key,
    this.gambar,
    this.fotoProfil,
    required this.pemosting,
    required this.judul,
    required this.tanggal,
    required this.id,
    required this.isActive,
    required this.onDelete,
    required this.onEdit,
    required this.onToggleStatus,
  });

  @override
  State<EditableNewsItem> createState() => _EditableNewsItemState();
}

class _EditableNewsItemState extends State<EditableNewsItem> {
  late bool _currentStatus;

  @override
  void initState() {
    super.initState();

    _currentStatus = widget.isActive;
  }

  @override
  void didUpdateWidget(EditableNewsItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      _currentStatus = widget.isActive;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        color: const Color.fromARGB(255, 255, 234, 226),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: widget.fotoProfil?.image,
                            radius: 20.0,
                            child: widget.fotoProfil == null 
                                ? const Icon(Icons.person) 
                                : null,
                          ),
                          const SizedBox(width: 12.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.pemosting,
                                style: const TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Color(0xFF1068BB),
                                ),
                              ),
                              Text(
                                widget.tanggal,
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
                      Switch(
                        value: _currentStatus,
                        onChanged: (bool newValue) {
                          setState(() {
                            _currentStatus = newValue;
                          });
                          widget.onToggleStatus(newValue);
                        },
                        activeColor: Colors.blue,
                        activeTrackColor: Colors.blue.withOpacity(0.4),
                        inactiveThumbColor: Colors.grey,
                        inactiveTrackColor: Colors.grey.withOpacity(0.4),
                      ),
                    ],
                  ),
                  
                  // Image (if available)
                  if (widget.gambar != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: SizedBox(
                          width: double.infinity,
                          height: 200,
                          child: widget.gambar!,
                        ),
                      ),
                    ),
                  
                  // Title
                  Text(
                    widget.judul,
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                    ),
                  ),
                  
                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailBerita(id: widget.id),
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
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: widget.onEdit,
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: widget.onDelete,
                          ),
                        ],
                      ),
                    ],
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
