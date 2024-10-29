import 'package:flutter/material.dart';

class DetailPeraturan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back),
        title: Text('Detail Paparan'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Menggunakan SingleChildScrollView untuk membuat tampilan scrollable pada layar kecil
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Menghapus TextField search
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[100],
                                foregroundColor: Colors.blue[600],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                              child: Text('Paparan'),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          // Membuat tabel bisa di-scroll jika terlalu besar untuk layar
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: constraints.maxHeight * 0.7,
                            ),
                            child: SingleChildScrollView(
                              child: Table(
                                columnWidths: {
                                  0: FlexColumnWidth(2),
                                  1: FlexColumnWidth(3),
                                },
                                border: TableBorder.all(color: Colors.grey),
                                children: [
                                  _buildTableRow('Detail Paparan',
                                      'Lorem ipsum dolor sit amet'),
                                  _buildTableRow('Jenis Dokumen', 'Lorem ipsum',
                                      isGray: true),
                                  _buildTableRow('Judul',
                                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'),
                                  _buildTableRow('T.E.U Badan',
                                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                                      isGray: true),
                                  _buildTableRow('No', 'Lorem'),
                                  _buildTableRow('Tahun Terbit', 'ipsum',
                                      isGray: true),
                                  _buildTableRow('Singkatan Jenis', 'dolor'),
                                  _buildTableRow('Tempat Penetapan', 'sit',
                                      isGray: true),
                                  _buildTableRow('Tanggal Penetapan', 'amet'),
                                  _buildTableRow(
                                      'Tanggal Pengundangan', 'consectetur',
                                      isGray: true),
                                  _buildTableRow('Subjek', 'adipiscing'),
                                  _buildTableRow(
                                      'Sumber', 'Lorem ipsum dolor sit amet',
                                      isGray: true),
                                  _buildTableRow(
                                      'Status Peraturan', 'Lorem ipsum'),
                                  _buildTableRow('Bahasa', 'Lorem ipsum',
                                      isGray: true),
                                  _buildTableRow('Lokasi', 'Lorem ipsum'),
                                  _buildTableRow('Bidang Hukum', 'Lorem ipsum',
                                      isGray: true),
                                  _buildTableRow(
                                      'Penanda Tangan', 'Lorem ipsum'),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.bar_chart),
                                label: Text('Infografis'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[600],
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.0),
                              ElevatedButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.download),
                                label: Text('Unduh'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[600],
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  TableRow _buildTableRow(String title, String value, {bool isGray = false}) {
    return TableRow(
      decoration: BoxDecoration(
        color: isGray ? Colors.grey[200] : Colors.white,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ],
    );
  }
}
