import 'package:calendar/lihatDatabase.dart';
import 'package:flutter/material.dart';
import 'package:calendar/utils/database_helper.dart';
import 'package:calendar/models/mark.dart';

class TestDatabase extends StatefulWidget {
  @override
  _TestDatabaseState createState() => _TestDatabaseState();
}

class _TestDatabaseState extends State<TestDatabase> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Mark> markList = [];

  // Controllers untuk menginput data
  final TextEditingController judulController = TextEditingController();
  final TextEditingController deskripsiController = TextEditingController();
  final TextEditingController tglAwalController = TextEditingController();
  final TextEditingController tglAkhirController = TextEditingController();
  final TextEditingController waktuAwalController = TextEditingController();
  final TextEditingController waktuAkhirController = TextEditingController();
  final TextEditingController lokasiController = TextEditingController();
  final TextEditingController warnaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData(); // Memuat data saat widget pertama kali dibuka
  }

  // Fungsi untuk mengambil data dari database
  void _loadData() async {
    List<Mark> marks = await dbHelper.getMarkList();
    setState(() {
      markList = marks;
    });
  }

  // Fungsi untuk menyimpan data baru ke database
  void _saveData() async {
    Mark newMark = Mark(
      judulController.text,
      deskripsiController.text,
      tglAwalController.text,
      tglAkhirController.text,
      waktuAwalController.text,
      waktuAkhirController.text,
      lokasiController.text,
      warnaController.text,
    );

    await dbHelper.insertMark(newMark);
    _loadData(); // Memuat ulang data setelah menambahkan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tes Database SQLite'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form input
            TextFormField(
              controller: judulController,
              decoration: InputDecoration(labelText: 'Judul'),
            ),
            TextFormField(
              controller: deskripsiController,
              decoration: InputDecoration(labelText: 'Deskripsi'),
            ),
            TextFormField(
              controller: tglAwalController,
              decoration: InputDecoration(labelText: 'Tanggal Awal'),
            ),
            TextFormField(
              controller: tglAkhirController,
              decoration: InputDecoration(labelText: 'Tanggal Akhir'),
            ),
            TextFormField(
              controller: waktuAwalController,
              decoration: InputDecoration(labelText: 'Waktu Awal'),
            ),
            TextFormField(
              controller: waktuAkhirController,
              decoration: InputDecoration(labelText: 'Waktu Akhir'),
            ),
            TextFormField(
              controller: lokasiController,
              decoration: InputDecoration(labelText: 'Lokasi'),
            ),
            TextFormField(
              controller: warnaController,
              decoration: InputDecoration(labelText: 'Warna'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _saveData,
              child: Text('Simpan Data'),
            ),
            Divider(height: 32.0),
            // Tampilkan data yang tersimpan
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MarkListScreen()),
                );
              },
              child: Text("Lihat Daftar Mark"),
            )
          ],
        ),
      ),
    );
  }
}
