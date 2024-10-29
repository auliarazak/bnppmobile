import 'package:calendar/calendarPage.dart';
import 'package:calendar/tesdatabase.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:calendar/utils/database_helper.dart';

void main() {
  // Memastikan sqflite menggunakan ffi di lingkungan desktop
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi; // Inisialisasi databaseFactory
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: CalendarPage(),
    );
  }
}

