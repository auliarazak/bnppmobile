import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:calendar/models/mark.dart';

class DatabaseHelper {
  static final DatabaseHelper _databaseHelper = DatabaseHelper._createInstance();
  static Database? _database; // Make _database nullable

  String markTable = 'mark_table';
  String colId = 'id';
  String colJudul = 'judul';
  String colDeskripsi = 'deskripsi';
  String colTglAwal = 'tglAwal';
  String colTglAkhir = 'tglAkhir';
  String colWaktuAwal = 'waktuAwal';
  String colWaktuAkhir = 'waktuAkhir';
  String colLokasi = 'lokasi';
  String colWarna = 'warna';

  DatabaseHelper._createInstance(); // Named constructor

  factory DatabaseHelper() {
    return _databaseHelper; // Return the initialized instance
  }

  Future<Database> get database async {
    // Check if _database is initialized
    if (_database == null) {
      _database = await initializeDatabase(); // Initialize the database
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'marks.db';

    var marksdatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return marksdatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $markTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colJudul TEXT, $colDeskripsi TEXT, $colTglAwal TEXT, $colTglAkhir TEXT, $colWaktuAwal TEXT, $colWaktuAkhir TEXT, $colLokasi TEXT, $colWarna TEXT)');
  }

  // Fetch operation: get all objects from the database
  Future<List<Map<String, dynamic>>> getMarkMapList() async {
    Database db = await this.database; // Ensure _database is initialized
    var result = await db.query(markTable);
    return result;
  }

  // Insert operation: Insert a mark object into the database
  Future<int> insertMark(Mark mark) async {
    Database db = await this.database; // Ensure _database is initialized
    var result = await db.insert(markTable, mark.toMap());
    return result;
  }

  // Update operation: Update a mark object and save it to the database
  Future<int> updateMark(Mark mark) async {
    Database db = await this.database; // Ensure _database is initialized
    var result = await db.update(markTable, mark.toMap(), where: '$colId = ?', whereArgs: [mark.id]);
    return result;
  }

  // Delete operation: Delete a mark object from the database
  Future<int> deleteMark(int id) async {
    var db = await this.database; // Ensure _database is initialized
    int result = await db.rawDelete('DELETE FROM $markTable WHERE $colId=$id');
    return result;
  }

  // Get the number of Mark objects in the database
  Future<int> getCount() async {
    Database db = await this.database; // Ensure _database is initialized
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT(*) from $markTable');
    int result = x.isNotEmpty ? x.first.values.first as int : 0;
    return result;
  }

  // Get the 'Map List' [List<Map>] and convert it to 'Mark List' [List<Mark>]
  Future<List<Mark>> getMarkList() async {
    var markMapList = await getMarkMapList();
    int count = markMapList.length;

    List<Mark> markList = [];

    for (int i = 0; i < count; i++) {
      markList.add(Mark.fromMapObject(markMapList[i]));
    }

    return markList;
  }
}
