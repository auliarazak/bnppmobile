import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'package:siranta/Menus/main_menu_old.dart';
import 'package:siranta/apicon.dart';

class FormInputPaparan extends StatefulWidget {
  const FormInputPaparan({super.key});

  @override
  _FormInputPaparanState createState() => _FormInputPaparanState();
}

class _FormInputPaparanState extends State<FormInputPaparan> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isSubmitting = false;
  late String _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  final Map<String, String> _data = {
    'user_id': '',
    'judul_paparan': '',
    'deskripsi_paparan': '',
    'tag': '',
    'pdf_path': '',
    'tgl_pembuatan': '',
    'tgl_upload': DateFormat('yyyy-MM-dd').format(DateTime.now()),
    'subjek': '',
    'pembuat': '',
  };

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('user_id')?.toString() ?? '1';
    });

    // Update _data dengan _userId yang baru diambil
    _data['user_id'] = _userId;
  }

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

    final url = Uri.parse('${ApiConfig.baseUrl}create-paparan');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(_data),
      );

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
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  bool _areAllFieldsFilled() {
    // Null-safe checks with default empty string
    return (_data['judul_paparan'] ?? '').isNotEmpty &&
        (_data['deskripsi_paparan'] ?? '').isNotEmpty &&
        (_data['pdf_path'] ?? '').isNotEmpty &&
        (_data['subjek'] ?? '').isNotEmpty &&
        (_data['tgl_pembuatan'] ?? '').isNotEmpty &&
        (_data['pembuat'] ?? '').isNotEmpty &&
        (_data['tag']!.isNotEmpty || ['3', '4', '5'].contains(_userId));
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
              'Form Input Paparan',
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
                      PageOne(
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

class PageOne extends StatefulWidget {
  final Function(Map<String, String>) onChanged;
  final Map<String, String> data;

  const PageOne({Key? key, required this.onChanged, required this.data})
      : super(key: key);

  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  String? selectedFileName;
  bool isUploading = false;
  List<String> tags = [
    'Data Evaluasi',
    'Kerja Sama',
    'Program dan Perencanaan'
  ];
  String? selectedTag;
  bool isLevelUserLoaded = false;
  int? levelUser;

  @override
  void initState() {
    super.initState();
    _checkUserLevel();
  }

  Future<void> _checkUserLevel() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getInt('user_id')?.toString();

      if (userId != null) {
        final response = await http.get(
          Uri.parse('${ApiConfig.baseUrl}cek-level/$userId'),
        );

        if (response.statusCode == 200) {
          setState(() {
            levelUser = json.decode(response.body)['level_user'];
            switch (levelUser) {
              case 3:
                selectedTag = 'Data Evaluasi';
                widget.data['tag'] = selectedTag!;
                break;
              case 4:
                selectedTag = 'Kerja Sama';
                widget.data['tag'] = selectedTag!;
                break;
              case 5:
                selectedTag = 'Program dan Perencanaan';
                widget.data['tag'] = selectedTag!;
                break;
            }
            isLevelUserLoaded = true;
          });

          widget.onChanged(widget.data);
        }
      }
    } catch (e) {
      showTopNotification(context, 'Error mengecek level user: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          const Text('Masukan Informasi Paparan',
              style: TextStyle(fontSize: 20, fontFamily: 'Plus Jakarta Sans')),
          const SizedBox(height: 10),
          _buildTextField(
            label: 'Judul Paparan',
            onChanged: (value) {
              widget.data['judul_paparan'] = value;
              widget.onChanged(widget.data);
            },
            initialValue: widget.data['judul_paparan'],
          ),
          const SizedBox(height: 10),
          _buildTextField(
            label: 'Deskripsi',
            onChanged: (value) {
              widget.data['deskripsi_paparan'] = value;
              widget.onChanged(widget.data);
            },
            initialValue: widget.data['deskripsi_paparan'],
          ),
          const SizedBox(height: 10),
          if (levelUser == 1) // Only show for level 1 users
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedTag,
                  hint: const Text('Pilih Bagian'),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Color(0xFF1068BB)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(color: Color(0xFF7AB2D3)),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  ),
                  items: tags.map((String tag) {
                    return DropdownMenuItem<String>(
                      value: tag,
                      child: Text(tag),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTag = newValue;
                      widget.data['tag'] = newValue ?? '';
                    });
                    widget.onChanged(widget.data);
                  },
                ),
                const SizedBox(height: 10),
              ],
            ),
          _buildTextField(
            label: 'Pembuat',
            onChanged: (value) {
              widget.data['pembuat'] = value;
              widget.onChanged(widget.data);
            },
            initialValue: widget.data['pembuat'],
          ),
          const SizedBox(height: 10),
          _buildTextField(
            label: 'Subjek',
            onChanged: (value) {
              widget.data['subjek'] = value;
              widget.onChanged(widget.data);
            },
            initialValue: widget.data['subjek'],
          ),
          const SizedBox(height: 10),
          _buildDatePicker(
            label: 'Tanggal Pembuatan',
            onChanged: (value) {
              widget.data['tgl_pembuatan'] = value;
              widget.onChanged(widget.data);
            },
            initialValue: widget.data['tgl_pembuatan'],
            context: context,
          ),
          const SizedBox(height: 10),
          _buildPdfField(),
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
            'PDF',
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
