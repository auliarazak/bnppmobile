import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';

import 'package:siranta/PDFViewer/pdf_viewer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

import 'package:siranta/apicon.dart';

class DetailPeraturanUU extends StatefulWidget {
  final int peraturanId;
  const DetailPeraturanUU({super.key, required this.peraturanId});

  @override
  // ignore: library_private_types_in_public_api
  _DetailPeraturanUUState createState() => _DetailPeraturanUUState();
}

class _DetailPeraturanUUState extends State<DetailPeraturanUU> {
  late Future<Map<String, dynamic>> _peraturanData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPeraturanDetail();
  }

  Future<void> _loadPeraturanDetail() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      _peraturanData = fetchPeraturanDetail(widget.peraturanId);
      await _peraturanData;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load data: ${e.toString()}';
      });
    }
  }

  Future<Map<String, dynamic>> fetchPeraturanDetail(int id) async {
    try {
      final response = await http
          .get(
        Uri.parse('${ApiConfig.baseUrl}peraturan-uu/$id'),
      )
          .timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Koneksi Error. Mohon Coba Lagi.');
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load peraturan detail: ${e.toString()}');
    }
  }

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '-';

    try {
      // Parse the ISO date string
      DateTime date = DateTime.parse(dateString);
      // Format to YYYY-MM-DD
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      return dateString; // Return original string if parsing fails
    }
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading Data...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red[400],
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            _error ?? 'An error occurred',
            style: TextStyle(
              color: Colors.red[700],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadPeraturanDetail,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showTopNotification(BuildContext context, String message) {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.lightBlue[100],
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.blue),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry?.remove();
    });
  }

  Future<void> downloadFile(String base64Pdf, BuildContext context,
      {String? defaultFileName}) async {
    PermissionStatus permissionStatus = await Permission.storage.request();
    if (permissionStatus.isGranted) {
      List<int> pdfBytes = base64Decode(base64Pdf);
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory != null) {
        String fileName = defaultFileName ?? 'downloaded_pdf';
        TextEditingController fileNameController =
            TextEditingController(text: fileName);
        await showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Masukan Nama File'),
              content: TextField(
                controller: fileNameController,
                decoration: const InputDecoration(
                    hintText: 'Pilih OK jika tidak ingin rename file.'),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );

        fileName = fileNameController.text.isNotEmpty
            ? fileNameController.text
            : defaultFileName ?? 'downloaded_pdf';
        String filePath = p.join(selectedDirectory, '$fileName.pdf');

        try {
          await File(filePath).writeAsBytes(pdfBytes);

          showTopNotification(
            // ignore: use_build_context_synchronously
            context,
            'File telah berhasil diunduh di $filePath',
          );
        } catch (e) {
          showTopNotification(
            // ignore: use_build_context_synchronously
            context,
            'Gagal mengunduh file: $e',
          );
        }
      } else {
        showTopNotification(
          // ignore: use_build_context_synchronously
          context,
          'tidak ada direktori yang dipilih',
        );
      }
    } else {
      // ignore: use_build_context_synchronously
      _showPermissionDialog(context);
    }
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content:
            const Text('This app needs storage permission to download files.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Permission.storage.request();
            },
            child: const Text('Grant Permission'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text('Detail Peraturan'),
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _error != null
              ? _buildErrorState()
              : LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: FutureBuilder<Map<String, dynamic>>(
                                  future: _peraturanData,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const SizedBox.shrink();
                                    }

                                    final data = snapshot.data!;
                                    return Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: ElevatedButton(
                                            onPressed: () {
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //     builder: (context) =>
                                              //         const ListPeraturanUU(),
                                              //   ),
                                              // );
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue[100],
                                              foregroundColor: Colors.blue[600],
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                            ),
                                            child: Text(data['jenis_peraturan']
                                                ['singkatan_jenis']),
                                          ),
                                        ),
                                        const SizedBox(height: 16.0),
                                        ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxHeight:
                                                constraints.maxHeight * 0.7,
                                          ),
                                          child: SingleChildScrollView(
                                            child: Table(
                                              columnWidths: const {
                                                0: FlexColumnWidth(2),
                                                1: FlexColumnWidth(3),
                                              },
                                              border: TableBorder.all(
                                                  color: Colors.grey),
                                              children: [
                                                _buildTableRow('Judul',
                                                    data['judul_peraturan']),
                                                _buildTableRow('T.E.U Badan',
                                                    data['teu']['nama_teu'],
                                                    isGray: true),
                                                _buildTableRow('Nomor',
                                                    data['nomor_peraturan']),
                                                _buildTableRow('Tahun Terbit',
                                                    data['tahun_peraturan'],
                                                    isGray: true),
                                                _buildTableRow(
                                                    'Singkatan Jenis',
                                                    data['jenis_peraturan']
                                                        ['singkatan_jenis']),
                                                _buildTableRow(
                                                    'Tempat Penetapan',
                                                    data[
                                                        'tempat_penetapan_peraturan'],
                                                    isGray: true),
                                                _buildTableRow(
                                                    'Tanggal Penetapan',
                                                    data[
                                                        'tgl_penetapan_peraturan']),
                                                _buildTableRow(
                                                    'Tanggal Pengundangan',
                                                    data[
                                                        'tgl_pengundangan_peraturan'],
                                                    isGray: true),
                                                _buildTableRow('Subjek',
                                                    data['subjek_peraturan']),
                                                _buildTableRow('Sumber',
                                                    data['sumber_peraturan'],
                                                    isGray: true),
                                                _buildTableRow(
                                                    'Status Peraturan',
                                                    data['status_peraturan']),
                                                _buildTableRow('Bahasa',
                                                    data['bahasa_peraturan'],
                                                    isGray: true),
                                                _buildTableRow('Lokasi',
                                                    data['lokasi_peraturan']),
                                                _buildTableRow(
                                                    'Bidang Hukum',
                                                    data[
                                                        'bidang_hukum_peraturan'],
                                                    isGray: true),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16.0),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                downloadFile(
                                                    data['pdf_path'], context,
                                                    defaultFileName: data[
                                                        'judul_peraturan']);
                                              },
                                              icon: const Icon(Icons.download),
                                              label: const Text('Download'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.blue[600],
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 8.0),
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        PdfViewerScreen(
                                                            title: data[
                                                                'judul_peraturan'],
                                                            pdfPath: data[
                                                                'pdf_path']),
                                                  ),
                                                );
                                              },
                                              icon: const Icon(Icons.file_open),
                                              label: const Text('Buka'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.blue[600],
                                                foregroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
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

  TableRow _buildTableRow(String title, String? value, {bool isGray = false}) {
    // Format the date if the title indicates it's a date field
    String displayValue = value ?? '-';
    if (title == 'Tanggal Penetapan' || title == 'Tanggal Pengundangan') {
      displayValue = formatDate(value);
    }

    return TableRow(
      decoration: BoxDecoration(
        color: isGray ? Colors.grey[200] : Colors.white,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child:
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(displayValue),
        ),
      ],
    );
  }
}
