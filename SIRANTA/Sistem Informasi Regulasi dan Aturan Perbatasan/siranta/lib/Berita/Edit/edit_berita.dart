import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:siranta/apicon.dart';
import 'package:siranta/Menus/main_menu_old.dart';

class EditBerita extends StatefulWidget {
  final int beritaId;

  const EditBerita({Key? key, required this.beritaId}) : super(key: key);

  @override
  State<EditBerita> createState() => _EditBeritaState();
}

class _EditBeritaState extends State<EditBerita> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  bool _isLoading = true;
  bool _isSubmitting = false;
  late String _userId;

  final Map<String, String> _data = {
    'user_id': '',
    'judul_berita': '',
    'deskripsi_berita': '',
    'tgl_berita': '',
    'foto_berita': '',
    'status': '0',
  };

  @override
  void initState() {
    super.initState();
    _loadUserId();
    _fetchBeritaDetails();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getInt('user_id')?.toString() ?? '1';
    });
    _data['user_id'] = _userId;
  }

  Future<void> _fetchBeritaDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}getEdit/${widget.beritaId}'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'];
        setState(() {
          _data['judul_berita'] = data['judul_berita'] ?? '';
          _data['deskripsi_berita'] = data['deskripsi_berita'] ?? '';
          _data['tgl_berita'] = data['tgl_berita'] ??
              DateFormat('yyyy-MM-dd').format(DateTime.now());
          _data['foto_berita'] = data['foto_berita'] ?? '';
          _data['status'] = (data['status'] ?? '0').toString();
          _isLoading = false;
        });
      } else {
        _showErrorNotification('Gagal memuat data berita');
      }
    } catch (e) {
      _showErrorNotification('Terjadi kesalahan: $e');
    }
  }

  void _showErrorNotification(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showSuccessNotification(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
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

  bool _validateData() {
  // Add more specific validation
  if (_data['judul_berita']?.trim().isEmpty ?? true) {
    _showErrorNotification('Judul berita tidak boleh kosong');
    return false;
  }
  if (_data['deskripsi_berita']?.trim().isEmpty ?? true) {
    _showErrorNotification('Deskripsi berita tidak boleh kosong');
    return false;
  }
  if (_data['foto_berita']?.isEmpty ?? true) {
    _showErrorNotification('Foto berita harus diupload');
    return false;
  }
  return true;
}

  void _submitData() async {
    if (!_validateData()) return;
    if (!_areAllFieldsFilled()) {
      _showErrorNotification('Data masih ada yang kosong!');
      return;
    }

    // Check if the widget is still mounted before proceeding
    if (!mounted) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      print('Sending data: ${jsonEncode(_data)}');
      final response = await http.put(
        // Change from http.post to http.put
        Uri.parse('${ApiConfig.baseUrl}update-berita/${widget.beritaId}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json' // Add accept header
        },
        body: jsonEncode(_data),
      );
      print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

      // Double-check mounting before updating UI
      if (!mounted) return;

      if (response.statusCode == 200) {
        _showSuccessNotification('Berita berhasil diperbarui!');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainMenuScreen()),
        );
      } else {
        _showErrorNotification(
          'Gagal memperbarui berita. Kode: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error details: $e');
    _showErrorNotification('Terjadi kesalahan: $e');
      if (!mounted) return;

      _showErrorNotification('Terjadi kesalahan: $e');
    } finally {
      // Only update state if widget is still mounted
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

  Future<void> _handleImageUpload() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        String filePath = result.files.single.path ?? '';
        if (filePath.isNotEmpty) {
          File file = File(filePath);
          List<int> fileBytes = await file.readAsBytes();

          if (fileBytes.length > 2000000) {
            _showErrorNotification('File terlalu besar untuk diupload');
          } else {
            String base64String = base64Encode(fileBytes);
            setState(() {
              _data['foto_berita'] = base64String;
            });
            _showSuccessNotification('File berhasil diupload');
          }
        }
      }
    } catch (e) {
      _showErrorNotification('Error saat upload file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'Memuat data berita...',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      );
    }

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
              'Edit Berita',
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
                      EditBeritaPageOne(
                        data: _data,
                        onChanged: (data) => _data.addAll(data),
                        onImageUpload: _handleImageUpload,
                      ),
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

class EditBeritaPageOne extends StatefulWidget {
  final Function(Map<String, String>) onChanged;
  final Map<String, String> data;
  final VoidCallback onImageUpload;

  const EditBeritaPageOne({
    Key? key,
    required this.onChanged,
    required this.data,
    required this.onImageUpload,
  }) : super(key: key);

  @override
  _EditBeritaPageOneState createState() => _EditBeritaPageOneState();
}

class _EditBeritaPageOneState extends State<EditBeritaPageOne> {
  String? selectedFileName;
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Text('Edit Berita',
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
            onPressed: isUploading ? null : widget.onImageUpload,
            icon: const Icon(Icons.upload_file),
            label: const Text('Ubah Foto'),
          ),
        ),
        const SizedBox(height: 5),
        if (widget.data['foto_berita']!.isNotEmpty)
          Row(
            children: [
              const Icon(Icons.image, color: Colors.blue),
              const SizedBox(width: 5),
              const Expanded(
                child: Text(
                  'Foto telah diupload',
                  style: TextStyle(color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
      ],
    );
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
