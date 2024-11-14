import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:siranta/Menus/mainMenu.dart';
import 'package:siranta/apicon.dart';

class FormInputPeraturan extends StatefulWidget {
  @override
  _FormInputPeraturanState createState() => _FormInputPeraturanState();
}

class _FormInputPeraturanState extends State<FormInputPeraturan> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isSubmitting = false;

  final Map<String, String> _data = {
    'user_id': '2',
    'judul_peraturan': '',
    'nomor_peraturan': '',
    'tahun_peraturan': '',
    'jenis_peraturan_id': '',
    'teu_id': '',
    'pdf_path': '',
    'tempat_penetapan_peraturan': '',
    'tgl_penetapan_peraturan': '',
    'tgl_pengundangan_peraturan': '',
    'subjek_peraturan': '',
    'sumber_peraturan': '',
    'status_peraturan': '',
    'bahasa_peraturan': '',
    'lokasi_peraturan': '',
    'bidang_hukum_peraturan': '',
    'penanda_tangan_peraturan': '',
    'lampiran': '',
    'abstrak': '',
    'peraturan_terkait': '',
  };

  void _nextPage() {
    if (_currentPage < 4) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      setState(() {
        _currentPage++;
      });
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
      setState(() {
        _currentPage--;
      });
    }
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

  void _submitData() async {
    if (!_areAllFieldsFilled()) {
      showTopNotification(context, 'Data masih ada yang kosong!');
      return;
    }

    // Set submitting state to true
    setState(() {
      _isSubmitting = true;
    });

    final url = Uri.parse('${ApiConfig.baseUrl}peraturan');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(_data),
      );

      // Only proceed if the widget is still mounted
      if (!mounted) return;

      if (response.statusCode == 200) {
        showTopNotification(context, 'Data berhasil dikirim!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainMenuScreen()),
        );
      } else {
        showTopNotification(
          context,
          'Gagal mengirim data. Kode: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (!mounted) return;
      showTopNotification(context, 'Terjadi kesalahan: $e');
    } finally {
      // Reset submitting state if the widget is still mounted
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  bool _areAllFieldsFilled() {
    return _data.values.every((value) => value.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF1068BB),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: _isSubmitting ? null : () => Navigator.pop(context),
            ),
            title: const Text(
              'From Input Peraturan',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 20,
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                LinearProgressIndicator(value: (_currentPage + 1) / 5),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: _isSubmitting
                        ? const NeverScrollableScrollPhysics()
                        : null,
                    onPageChanged: (page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: [
                      PageOne(
                          data: _data, onChanged: (data) => _data.addAll(data)),
                      PageTwo(
                          data: _data, onChanged: (data) => _data.addAll(data)),
                      PageThree(
                          data: _data, onChanged: (data) => _data.addAll(data)),
                      PageFour(
                          data: _data, onChanged: (data) => _data.addAll(data)),
                      PageFive(data: _data, onSubmit: _submitData),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_currentPage > 0)
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : _previousPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEAF1FF),
                          foregroundColor: const Color(0xFF1068BB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text('Sebelumnya'),
                      ),
                    if (_currentPage < 4)
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1068BB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text('Selanjutnya'),
                      ),
                    if (_currentPage == 4)
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitData,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1068BB),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: const Text('Kirim Data'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // Loading overlay
        if (_isSubmitting)
          Container(
            color: Colors.black54,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Sedang mengirim data...',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

const List<Map<String, String>> jenisPeraturanList = [
  {'value': '1', 'label': 'Undang-Undang'},
  {'value': '2', 'label': 'Peraturan Presiden'},
  {'value': '3', 'label': 'Peraturan Pemerintah'},
  {'value': '4', 'label': 'Peraturan BNPP'},
  {'value': '5', 'label': 'Peraturan Kementrian'},
  {'value': '6', 'label': 'Naskah Kesepahaman'},
];

const List<Map<String, String>> teuList = [
  {'value': '1', 'label': 'BNPP'},
  {'value': '2', 'label': 'Kementrian Dalam Negeri, Indonesia'},
  {'value': '3', 'label': 'Kementrian Luar Negeri'},
  {'value': '4', 'label': 'Sekretarian Negara'},
];

class PageOne extends StatefulWidget {
  final Function(Map<String, String>) onChanged;
  final Map<String, String> data;

  const PageOne({Key? key, required this.onChanged, required this.data})
      : super(key: key);

  @override
  _PageOneState createState() => _PageOneState();
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

class _PageOneState extends State<PageOne> {
  String? selectedFileName;
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Stack(
        children: [
          Column(
            children: [
              const Text('1. Informasi Dasar',
                  style:
                      TextStyle(fontSize: 20, fontFamily: 'Plus Jakarta Sans')),
              const SizedBox(height: 10),
              _buildTextField(
                label: 'Judul Peraturan',
                onChanged: (value) {
                  widget.data['judul_peraturan'] = value;
                  widget.onChanged(widget.data);
                },
                initialValue: widget.data['judul_peraturan'],
              ),
              const SizedBox(height: 10),
              _buildTextField(
                label: 'Nomor Peraturan',
                onChanged: (value) {
                  widget.data['nomor_peraturan'] = value;
                  widget.onChanged(widget.data);
                },
                initialValue: widget.data['nomor_peraturan'],
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 10),
              _buildTextField(
                label: 'Tahun Peraturan',
                onChanged: (value) {
                  widget.data['tahun_peraturan'] = value;
                  widget.onChanged(widget.data);
                },
                initialValue: widget.data['tahun_peraturan'],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
              ),
              const SizedBox(height: 10),
              _buildDropdown(
                label: 'Jenis Peraturan',
                items: jenisPeraturanList,
                value: widget.data['jenis_peraturan_id'],
                onChanged: (value) {
                  widget.data['jenis_peraturan_id'] = value!;
                  widget.onChanged(widget.data);
                },
              ),
              const SizedBox(height: 10),
              _buildDropdown(
                label: 'TEU',
                items: teuList,
                value: widget.data['teu_id'],
                onChanged: (value) {
                  widget.data['teu_id'] = value!;
                  widget.onChanged(widget.data);
                },
              ),
              const SizedBox(height: 10),
              _buildPdfField(),
            ],
          ),
          if (isUploading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Mengupload file...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Plus Jakarta Sans',
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPdfField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'PDF Path',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              color: Color(0xFF201E43),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            onPressed: isUploading ? null : _handleFileUpload,
            icon: const Icon(Icons.upload_file),
            label: const Text('Tambahkan File'),
          ),
        ),
        const SizedBox(height: 5),
        if (selectedFileName != null)
          Row(
            children: [
              const Icon(Icons.insert_drive_file, color: Colors.blue),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  selectedFileName!,
                  style: const TextStyle(color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Future<void> _handleFileUpload() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          isUploading = true;
          selectedFileName = result.files.single.name;
        });

        String filePath = result.files.single.path ?? '';
        if (filePath.isNotEmpty) {
          File file = File(filePath);
          List<int> fileBytes = await file.readAsBytes();

          if (fileBytes.length > 2000000000) {
            setState(() {
              selectedFileName = 'File terlalu besar';
              widget.data['pdf_path'] = 'file terlalu besar';
            });

            showTopNotification(
              context,
              'File terlalu besar untuk diupload',
            );
          } else {
            String base64String = base64Encode(fileBytes);
            setState(() {
              widget.data['pdf_path'] = base64String;
            });
            widget.onChanged(widget.data);

            showTopNotification(
              context,
              'File berhasil diupload',
            );
          }
        }
      }
    } catch (e) {
      showTopNotification(
        context,
        'Error saat upload file: $e',
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  Widget _buildTextField({
    required String label,
    required ValueChanged<String> onChanged,
    String? initialValue,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 14,
          color: Color(0xFF201E43),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Color(0xFF1068BB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Color(0xFF7AB2D3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Color(0xFF1068BB), width: 2),
        ),
        filled: true,
        fillColor: const Color.fromARGB(0, 237, 243, 255),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      ),
      onChanged: onChanged,
      controller: TextEditingController(text: initialValue),
      inputFormatters: inputFormatters,
      style: const TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 12,
        color: Colors.black,
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<Map<String, String>> items,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: items.any((item) => item['value'] == value) ? value : null,
          onChanged: onChanged,
          isExpanded: true,
          menuMaxHeight: 200,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              color: Color(0xFF201E43),
              fontWeight: FontWeight.w100,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Color(0xFF1068BB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Color(0xFF7AB2D3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Color(0xFF1068BB), width: 2),
            ),
            filled: true,
            fillColor: const Color.fromARGB(0, 237, 243, 255),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          ),
          items:
              items.map<DropdownMenuItem<String>>((Map<String, String> item) {
            return DropdownMenuItem<String>(
              value: item['value'],
              child: Container(
                constraints: const BoxConstraints(maxWidth: 250),
                child: Text(
                  item['label']!,
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'Plus Jakarta Sans',
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class PageTwo extends StatefulWidget {
  final Function(Map<String, String>) onChanged;
  final Map<String, String> data;

  const PageTwo({Key? key, required this.onChanged, required this.data})
      : super(key: key);

  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  late TextEditingController _tglPenetapanController;
  late TextEditingController _tglPengundanganController;

  @override
  void initState() {
    super.initState();
    _tglPenetapanController =
        TextEditingController(text: widget.data['tgl_penetapan_peraturan']);
    _tglPengundanganController =
        TextEditingController(text: widget.data['tgl_pengundangan_peraturan']);
  }

  @override
  void dispose() {
    _tglPenetapanController.dispose();
    _tglPengundanganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const Text('2. Detail Penerbitan', style: TextStyle(fontSize: 20)),
          const SizedBox(height: 10),
          _buildTextField(
            label: 'Tempat Penetapan Peraturan',
            onChanged: (value) {
              widget.data['tempat_penetapan_peraturan'] = value;
              widget.onChanged(widget.data);
            },
            initialValue: widget.data['tempat_penetapan_peraturan'],
          ),
          const SizedBox(height: 10),
          _buildDatePicker(
            label: 'Tanggal Penetapan Peraturan',
            onChanged: (value) {
              widget.data['tgl_penetapan_peraturan'] = value;
              _tglPenetapanController.text = value;
              widget.onChanged(widget.data);
            },
            initialValue: widget.data['tgl_penetapan_peraturan'],
            context: context,
            controller: _tglPenetapanController,
          ),
          const SizedBox(height: 10),
          _buildDatePicker(
            label: 'Tanggal Pengundangan Peraturan',
            onChanged: (value) {
              widget.data['tgl_pengundangan_peraturan'] = value;
              _tglPengundanganController.text = value;
              widget.onChanged(widget.data);
            },
            initialValue: widget.data['tgl_pengundangan_peraturan'],
            context: context,
            controller: _tglPengundanganController,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required ValueChanged<String> onChanged,
    String? initialValue,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 14,
          color: Color(0xFF201E43),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Color(0xFF1068BB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Color(0xFF7AB2D3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: Color(0xFF1068BB), width: 2),
        ),
        filled: true,
        fillColor: const Color.fromARGB(0, 237, 243, 255),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      ),
      onChanged: onChanged,
      controller: TextEditingController(text: initialValue),
      style: const TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 12,
        color: Colors.black,
      ),
    );
  }

  Widget _buildDatePicker({
    required String label,
    required Function(String) onChanged,
    String? initialValue,
    required BuildContext context,
    required TextEditingController controller,
  }) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: initialValue != null && initialValue.isNotEmpty
              ? DateFormat('yyyy-MM-dd').parse(initialValue)
              : DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: const Color(0xFF1068BB),
                colorScheme:
                    const ColorScheme.light(primary: Color(0xFF1068BB)),
                buttonTheme:
                    const ButtonThemeData(textTheme: ButtonTextTheme.primary),
              ),
              child: child ?? const SizedBox(),
            );
          },
        );

        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
          onChanged(formattedDate);
          controller.text = formattedDate;
        }
      },
      child: AbsorbPointer(
        child: TextField(
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              color: Color(0xFF201E43),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Color(0xFF1068BB)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Color(0xFF7AB2D3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: const BorderSide(color: Color(0xFF1068BB), width: 2),
            ),
            filled: true,
            fillColor: const Color.fromARGB(0, 237, 243, 255),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          ),
          controller: controller,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class PageThree extends StatelessWidget {
  final Function(Map<String, String>) onChanged;
  final Map<String, String> data;

  const PageThree({Key? key, required this.onChanged, required this.data})
      : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Text('3. Informasi Tambahan',
                style:
                    TextStyle(fontSize: 20, fontFamily: 'Plus Jakarta Sans')),
            const SizedBox(height: 10),
            _buildTextField(
              label: 'Subjek Peraturan',
              onChanged: (value) {
                data['subjek_peraturan'] = value;
                onChanged(data);
              },
              initialValue: data['subjek_peraturan'],
            ),
            const SizedBox(height: 10),
            _buildTextField(
              label: 'Sumber Peraturan',
              onChanged: (value) {
                data['sumber_peraturan'] = value;
                onChanged(data);
              },
              initialValue: data['sumber_peraturan'],
            ),
            const SizedBox(height: 10),
            _buildTextField(
              label: 'Status Peraturan',
              onChanged: (value) {
                data['status_peraturan'] = value;
                onChanged(data);
              },
              initialValue: data['status_peraturan'],
            ),
            const SizedBox(height: 10),
            _buildTextField(
              label: 'Bahasa Peraturan',
              onChanged: (value) {
                data['bahasa_peraturan'] = value;
                onChanged(data);
              },
              initialValue: data['bahasa_peraturan'],
            ),
            const SizedBox(height: 10),
            _buildTextField(
              label: 'Lokasi Peraturan',
              onChanged: (value) {
                data['lokasi_peraturan'] = value;
                onChanged(data);
              },
              initialValue: data['lokasi_peraturan'],
            ),
            const SizedBox(height: 10),
            _buildTextField(
              label: 'Bidang Hukum',
              onChanged: (value) {
                data['bidang_hukum_peraturan'] = value;
                onChanged(data);
              },
              initialValue: data['bidang_hukum_peraturan'],
            ),
            const SizedBox(height: 10),
            _buildTextField(
              label: 'Penanda Tangan Peraturan',
              onChanged: (value) {
                data['penanda_tangan_peraturan'] = value;
                onChanged(data);
              },
              initialValue: data['penanda_tangan_peraturan'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required ValueChanged<String> onChanged,
    String? initialValue,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 14,
          color: Color(0xFF201E43),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Color(0xFF1068BB),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Color(0xFF7AB2D3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Color(0xFF1068BB),
            width: 2,
          ),
        ),
        filled: true,
        fillColor: const Color.fromARGB(0, 237, 243, 255),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      ),
      onChanged: onChanged,
      controller: TextEditingController(text: initialValue),
      style: const TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 12,
        color: Colors.black,
      ),
    );
  }
}

class PageFour extends StatelessWidget {
  final Function(Map<String, String>) onChanged;
  final Map<String, String> data;

  const PageFour({Key? key, required this.onChanged, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const Center(
            child: Text('4. Lampiran dan Abstrak Lampiran',
                style:
                    TextStyle(fontSize: 20, fontFamily: 'Plus Jakarta Sans')),
          ),
          const SizedBox(
            height: 10,
          ),
          _buildTextField(
            label: 'Lampiran',
            onChanged: (value) {
              data['lampiran'] = value;
              onChanged(data);
            },
            initialValue: data['lampiran'],
          ),
          const SizedBox(
            height: 10,
          ),
          _buildTextField(
            label: 'Abstrak',
            onChanged: (value) {
              data['abstrak'] = value;
              onChanged(data);
            },
            initialValue: data['abstrak'],
          ),
          const SizedBox(
            height: 10,
          ),
          _buildTextField(
            label: 'Peraturan Terkait',
            onChanged: (value) {
              data['peraturan_terkait'] = value;
              onChanged(data);
            },
            initialValue: data['peraturan_terkait'],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required ValueChanged<String> onChanged,
    String? initialValue,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 14,
          color: Color(0xFF201E43),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Color(0xFF1068BB),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Color(0xFF7AB2D3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: Color(0xFF1068BB),
            width: 2,
          ),
        ),
        filled: true,
        fillColor: const Color.fromARGB(0, 237, 243, 255),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      ),
      onChanged: onChanged,
      controller: TextEditingController(text: initialValue),
      style: const TextStyle(
        fontFamily: 'Plus Jakarta Sans',
        fontSize: 12,
        color: Colors.black,
      ),
    );
  }
}

class PageFive extends StatelessWidget {
  final Function() onSubmit;
  final Map<String, String> data;

  const PageFive({Key? key, required this.onSubmit, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/sure.png', width: 200, height: 200),
          const Text('Data akan dikirim, apakah anda sudah yakin?'),
        ],
      ),
    );
  }
}
