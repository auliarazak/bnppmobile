import 'package:flutter/material.dart';
import 'package:calendar/utils/database_helper.dart';
import 'package:calendar/models/mark.dart';

class MarkListScreen extends StatefulWidget {
  @override
  _MarkListScreenState createState() => _MarkListScreenState();
}

class _MarkListScreenState extends State<MarkListScreen> {
  List<Mark> _markList = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  // Fetch data from the database
  void _fetchData() async {
    List<Mark> markList = await _databaseHelper.getMarkList();
    setState(() {
      _markList = markList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Daftar Mark"),
      ),
      body: _markList.isEmpty
          ? Center(child: Text("Tidak ada data"))
          : ListView.builder(
              itemCount: _markList.length,
              itemBuilder: (context, index) {
                final mark = _markList[index];
                return Card(
                  child: ListTile(
                    title: Text(mark.judul),
                    subtitle: Text(
                        'Deskripsi: ${mark.deskripsi}\nTanggal Awal: ${mark.tglAwal}\nTanggal Akhir: ${mark.tglAkhir}'),
                  ),
                );
              },
            ),
    );
  }
}
