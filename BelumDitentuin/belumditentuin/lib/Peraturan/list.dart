import 'package:flutter/material.dart';

class ListPeraturan extends StatefulWidget {
  const ListPeraturan({super.key});

  @override
  State<ListPeraturan> createState() => _ListPeraturanState();
}

class _ListPeraturanState extends State<ListPeraturan> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isDetailSearchVisible = false;

  // List contoh data peraturan untuk ditampilkan
  final List<Map<String, String>> _peraturanList = [
    {
      'title': 'Peraturan Badan Nomor 1 Tahun 2024',
      'description':
          'Peraturan Badan Nasional Pengelola Perbatasan Nomor 1 Tahun 2024 tentang Rencana Aksi Pengelolaan Batas Wilayah Negara dan Kawasan Perbatasan Tahun 2024',
    },
    {
      'title': 'Peraturan Badan Nomor 7 Tahun 2024',
      'description':
          'Peraturan Badan Nasional Penanggulangan Bencana Nomor 7 Tahun 2024 tentang Standar Operasional Penanggulangan Bencana di Wilayah Perbatasan',
    },
    {
      'title': 'Peraturan Badan Nomor 3 Tahun 2024',
      'description':
          'Peraturan Badan Keamanan Laut Nomor 3 Tahun 2024 tentang Pengawasan Laut di Wilayah Perbatasan',
    },
    {
      'title': 'Peraturan Badan Nomor 4 Tahun 2024',
      'description':
          'Peraturan Badan Nasional Penanggulangan Terorisme Nomor 4 Tahun 2024 tentang Strategi Pengamanan Wilayah Perbatasan dari Ancaman Terorisme',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1068BB),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Peraturan',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Pencarian
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'search...',
                      hintStyle: TextStyle(color: Colors.grey),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.red,
                      ),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 15, horizontal: 10), // Padding ditambah
                    ),
                    onTap: () {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                if (_isSearching)
                  ElevatedButton(
                    onPressed: () {
                      print('Mencari: ${_searchController.text}');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Colors.blue,
                      onPrimary: Colors.white,
                    ),
                    child: const Text('Cari'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            // Pencarian Detail
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isDetailSearchVisible = !_isDetailSearchVisible;
                  });
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Pencarian Detail',
                      style: TextStyle(color: Colors.black),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _isDetailSearchVisible
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
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
                  _buildSearchButton(), // Tombol yang diubah
                ],
              ),
            ],
            const SizedBox(height: 20),
            // Daftar peraturan yang dapat di-scroll
            Expanded(
              child: ListView.builder(
                itemCount: _peraturanList.length,
                itemBuilder: (context, index) {
                  return _buildPeraturanCard(
                    _peraturanList[index]['title']!,
                    _peraturanList[index]['description']!,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membuat card peraturan seperti pada gambar
  Widget _buildPeraturanCard(String title, String description) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Sudut rounded
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header bagian atas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Perban',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xff198754), // Warna hijau dengan kode 0xff
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Text(
                    'Berlaku',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Divider pembatas antara "Berlaku" dan "Peraturan Badan"
            const Divider(
              color: Color.fromARGB(109, 63, 58, 58),// Warna hitam
              thickness: 1, // Ketebalan garis
            ),
            const SizedBox(height: 10),
            // Icon PDF dan detail peraturan
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon PDF
                const Icon(
                  Icons.picture_as_pdf,
                  color: Colors.blue,
                  size: 40,
                ),
                const SizedBox(width: 10),
                // Detail peraturan
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(description),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Divider pembatas antara teks peraturan dengan tombol unduh
            const Divider(
              color: Color.fromARGB(109, 63, 58, 58), // Warna hitam
              thickness: 1, // Ketebalan garis
            ),
           const SizedBox(height: 10),
// Tombol Unduh
Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    ElevatedButton.icon(
      onPressed: () {
        print('Mengunduh peraturan...');
      },
      icon: const Icon(Icons.download),
      label: const Text('Unduh'),
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,
        onPrimary: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5), // Border radius circular
        ),
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
          contentPadding: const EdgeInsets.symmetric(
              vertical: 15, horizontal: 10), // Padding ditambah
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, List<String> options) {
    return SizedBox(
      width: 160, // Lebar diperbesar
      height: 50, // Tinggi diperbesar
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
              vertical: 15, horizontal: 10), // Padding ditambah
        ),
        items: options.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            
          });
        },
      ),
    );
  }

  Widget _buildSearchButton() {
  return SizedBox(
    width: 160,  // Lebar sama dengan TextField
    height: 50,  // Tinggi sama dengan TextField
    child: ElevatedButton(
      onPressed: () {
        print('Mencari...');
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.blue,    // Background button
        onPrimary: Colors.white, // Warna teks button
      ),
      child: const Text('Cari'),
    ),
  );
}

}