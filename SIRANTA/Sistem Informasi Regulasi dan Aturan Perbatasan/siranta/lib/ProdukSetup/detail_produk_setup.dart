import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';
import 'package:siranta/PDFViewer/pdf_viewer.dart';
import 'package:siranta/ProdukSetup/list_produk_setup.dart';

import 'package:siranta/apicon.dart';

class DetailProdukSetup extends StatefulWidget {
  final int produkSetupId;
  const DetailProdukSetup({super.key, required this.produkSetupId});

  @override
  State<DetailProdukSetup> createState() => _DetailProdukSetupState();
}

class _DetailProdukSetupState extends State<DetailProdukSetup> {
  late Future<Map<String, dynamic>> _produkSetupData;
  bool _isLoading = true;
  String? _error;

  Future<Map<String, dynamic>> fetchProdukSetupDetail(int id) async {
    try {
      final url = '${ApiConfig.baseUrl}detail-produk-setup/$id';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Koneksi Error. Mohon Coba Lagi.');
        },
      );


      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Server error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Detailed Error: $e');
      throw Exception(
          'Gagal untuk menampilkan detail produk setup: ${e.toString()}');
    }
  }

  Future<void> _loadProdukSetupDetail() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      _produkSetupData = fetchProdukSetupDetail(widget.produkSetupId);
      await _produkSetupData;

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Gagal untuk menampilkan detail produk setup: ${e.toString()}';
      });
    }
  }

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '-';

    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      return dateString;
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
            _error ?? 'Terjadi Kesalahan',
            style: TextStyle(
              color: Colors.red[700],
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _loadProdukSetupDetail,
            icon: const Icon(Icons.refresh),
            label: const Text('Coba Lagi'),
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
            context,
            'File telah berhasil diunduh di $filePath',
          );
        } catch (e) {
          showTopNotification(
            context,
            'Gagal mengunduh file: $e',
          );
        }
      } else {
        showTopNotification(
          context,
          'tidak ada direktori yang dipilih',
        );
      }
    } else {
      _showPermissionDialog(context);
    }
  }

  void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Izin Dibutuhkan'),
        content: const Text(
            'Aplikasi ini membutuhkan izin untuk mengakses penyimpanan.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Permission.storage.request();
            },
            child: const Text('Beri Izin'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String judul, String? value, {bool isGray = false}) {
    String displayValue = value ?? '-';
    if (judul == 'Tanggal Pembuatan' || judul == 'Tanggal Upload') {
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
              Text(judul, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(displayValue),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _loadProdukSetupDetail();
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
                        child: Center(
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
                                    future: _produkSetupData,
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
                                                //         const ListPaparan(),
                                                //   ),
                                                // );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.blue[100],
                                                foregroundColor:
                                                    Colors.blue[600],
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                              ),
                                              child: Text(data['tag']),
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
                                                      data['judul_setup']),
                                                  _buildTableRow(
                                                      "Deskripsi",
                                                      data[
                                                          'deskripsi_setup']),
                                                  _buildTableRow(
                                                      "Pengupload",
                                                      data['user']['data_user']
                                                          ['nama']),
                                                  _buildTableRow(
                                                      'Tanggal Pembuatan',
                                                      data['tgl_pembuatan']),
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
                                                      data['file'], context,
                                                      defaultFileName: data[
                                                          'judul_setup']);
                                                },
                                                icon:
                                                    const Icon(Icons.download),
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
                                                                  'judul_setup'],
                                                              pdfPath: data[
                                                                  'file']),
                                                    ),
                                                  );
                                                },
                                                icon:
                                                    const Icon(Icons.file_open),
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
                      ),
                    );
                  },
                ),
    );
  }
}
