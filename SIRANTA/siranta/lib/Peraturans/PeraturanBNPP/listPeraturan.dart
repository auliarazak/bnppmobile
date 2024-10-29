import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ListPeraturan extends StatefulWidget {
  const ListPeraturan({super.key});

  @override
  State<ListPeraturan> createState() => _ListPeraturanState();
}

class _ListPeraturanState extends State<ListPeraturan> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isDetailSearchVisible = false;

  // List to hold the API data
  List _peraturanList = [];

  // Fetch data from API
  Future<void> fetchPeraturan() async {
    final response = await http.get(Uri.parse('https://generous-joint-ape.ngrok-free.app/api/peraturan-bnpp'));
    if (response.statusCode == 200) {
      setState(() {
        _peraturanList = json.decode(response.body);
      });
    } else {
      // Handle API error
      print('Failed to load peraturan');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPeraturan(); // Fetch API data when the widget is initialized
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
          'Peraturan',
          style: TextStyle(color: Colors.white, fontFamily: 'Plus Jakarta Sans', fontSize: 20),
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
                      hintText: 'search...',
                      hintStyle: TextStyle(color: Color.fromARGB(255, 214, 214, 214)),
                      prefixIcon: Icon(Icons.search, color: Colors.red),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    ),
                    onTap: () => setState(() => _isSearching = true),
                  ),
                ),
                const SizedBox(width: 8),
                if (_isSearching)
                  ElevatedButton(
                    onPressed: () {
                      print('Mencari: ${_searchController.text}');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Cari'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: () => setState(() => _isDetailSearchVisible = !_isDetailSearchVisible),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Pencarian Detail', style: TextStyle(color: Colors.black)),
                    const SizedBox(width: 8),
                    Icon(_isDetailSearchVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: Colors.black),
                  ],
                ),
              ),
            ),
            if (_isDetailSearchVisible) ...[
              const SizedBox(height: 15),
              Wrap(
                spacing: 60.0,
                runSpacing: 30.0,
                children: [
                  _buildTextField('Nomor'),
                  _buildTextField('Tahun'),
                  _buildSearchButton(),
                ],
              ),
            ],
            const SizedBox(height: 20),
            Expanded(
              child: _peraturanList.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _peraturanList.length,
                      itemBuilder: (context, index) {
                        final peraturan = _peraturanList[index];
                        return _buildPeraturanCard(
                          peraturan['judul_peraturan'] ?? 'Judul tidak tersedia',
                          peraturan['abstrak'] ?? 'Abstrak tidak tersedia',
                          peraturan['singkatan_jenis'] ?? 'Jenis tidak tersedia',
                          peraturan['nama_tipe'] ?? 'Tipe tidak tersedia',
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeraturanCard(String title, String abstrak, String singkatanJenis, String namaTipe) {
    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              singkatanJenis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Divider(color: Color.fromARGB(109, 63, 58, 58), thickness: 1),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.slideshow, // Replace with appropriate icon if needed
                  color: Colors.blue,
                  size: 40,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
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
                    print('Melihat Peraturan');
                  },
                  icon: const Icon(Icons.remove_red_eye),
                  label: const Text('View'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText) {
    return SizedBox(
      width: 160,
      height: 50,
      child: TextField(
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        ),
      ),
    );
  }

  Widget _buildSearchButton() {
    return SizedBox(
      width: 160,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          print('Mencari...');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        child: const Text('Cari'),
      ),
    );
  }
}
