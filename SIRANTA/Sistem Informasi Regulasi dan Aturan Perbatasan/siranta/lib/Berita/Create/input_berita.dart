import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'package:siranta/Menus/main_menu_old.dart';
import 'package:siranta/apicon.dart';

class InputBerita extends StatefulWidget {
  const InputBerita({super.key});

  @override
  State<InputBerita> createState() => _InputBeritaState();
}

class _InputBeritaState extends State<InputBerita> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isSubmitting = false;
  late String _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('user_id')?.toString() ?? '1';
    });
    _data['user_id'] = _userId;
  }

  final Map<String, String> _data = {
    'user_id': '',
    'judul_berita': '',
    'deskripsi_berita': '',
    'tgl_berita': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'foto_berita': '',
    'status': '0', // Default to true/active
  };

  void _nextPage() {
    if (_currentPage < 1) {
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

  void _submitData() async {
    if (!_areAllFieldsFilled()) {
      showTopNotification(context, 'Data masih ada yang kosong!');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final url = Uri.parse('${ApiConfig.baseUrl}create-berita');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(_data),
      );

      if (!mounted) return;

      if (response.statusCode == 201) {
        showTopNotification(context, 'Berita berhasil ditambahkan!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainMenuScreen()),
        );
      } else {
        showTopNotification(
          context,
          'Gagal menambahkan berita. Kode: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (!mounted) return;
      showTopNotification(context, 'Terjadi kesalahan: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  bool _areAllFieldsFilled() {
    return _data['judul_berita']!.isNotEmpty &&
        _data['deskripsi_berita']!.isNotEmpty &&
        _data['tgl_berita']!.isNotEmpty &&
        _data['foto_berita']!.isNotEmpty;
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
              'Form Input Berita',
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
                LinearProgressIndicator(value: (_currentPage + 1) / 2),
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
                      BeritaPageOne(
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
                    if (_currentPage < 1)
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
                  ],
                ),
              ],
            ),
          ),
        ),
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

class BeritaPageOne extends StatefulWidget {
  final Function(Map<String, String>) onChanged;
  final Map<String, String> data;

  const BeritaPageOne({Key? key, required this.onChanged, required this.data})
      : super(key: key);

  @override
  _BeritaPageOneState createState() => _BeritaPageOneState();
}

class _BeritaPageOneState extends State<BeritaPageOne> {
  String? selectedFileName;
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Text('Input Berita',
                style:
                    TextStyle(fontSize: 20, fontFamily: 'Plus Jakarta Sans')),
            const SizedBox(height: 10),
            _buildTextField(
              label: 'Judul Berita',
              onChanged: (value) {
                widget.data['judul_berita'] = value;
                widget.onChanged(widget.data);
              },
              initialValue: widget.data['judul_berita'],
            ),
            const SizedBox(height: 10),
            _buildTextField(
              label: 'Deskripsi Berita',
              onChanged: (value) {
                widget.data['deskripsi_berita'] = value;
                widget.onChanged(widget.data);
              },
              initialValue: widget.data['deskripsi_berita'],
              maxLines: 5,
            ),
            const SizedBox(height: 10),
            _buildDatePicker(
              label: 'Tanggal Berita',
              onChanged: (value) {
                widget.data['tgl_berita'] = value;
                widget.onChanged(widget.data);
              },
              initialValue: widget.data['tgl_berita'],
              context: context,
            ),
            const SizedBox(height: 10),
            _buildImageField(),
          ],
        ),
      ),
    );
  }

  Widget _buildImageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Foto Berita',
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
            onPressed: isUploading ? null : _handleImageUpload,
            icon: const Icon(Icons.upload_file),
            label: const Text('Tambahkan Foto'),
          ),
        ),
        const SizedBox(height: 5),
        if (selectedFileName != null)
          Row(
            children: [
              const Icon(Icons.image, color: Colors.blue),
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

  Future<void> _handleImageUpload() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
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

          if (fileBytes.length > 2000000) {
            setState(() {
              selectedFileName = 'File terlalu besar';
              widget.data['foto_berita'] = '';
            });

            showTopNotification(
              context,
              'File terlalu besar untuk diupload',
            );
          } else {
            String base64String = base64Encode(fileBytes);
            setState(() {
              widget.data['foto_berita'] = base64String;
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
    int maxLines = 1,
  }) {
    return TextField(
      maxLines: maxLines,
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
          controller: TextEditingController(text: initialValue),
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
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onSubmit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1068BB),
              foregroundColor: Colors.white,
            ),
            child: const Text('Kirim Data'),
          ),
        ],
      ),
    );
  }
}
