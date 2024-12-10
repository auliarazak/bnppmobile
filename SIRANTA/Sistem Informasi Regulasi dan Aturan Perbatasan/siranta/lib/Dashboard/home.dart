import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:siranta/Berita/detail_berita.dart';
import 'package:siranta/Menus/sub_mainmenu.dart';
import 'package:http/http.dart' as http;
import 'package:siranta/Menus/mainmenu.dart';
import 'package:siranta/Profil/profile_page.dart';
import 'package:siranta/apicon.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class NewsModel {
  final int id;
  final String title;
  final String date;
  final String imageBase64;
  Image? _decodedImage;

  Image? get decodedImage => _decodedImage;

  NewsModel({
    required this.id,
    required this.title,
    required this.date,
    required this.imageBase64,
  }) {
    _decodeImage();
  }

  void _decodeImage() {
    if (imageBase64.isNotEmpty) {
      try {
        String cleanBase64 = imageBase64.trim();

        if (cleanBase64.contains(';base64,')) {
          cleanBase64 = cleanBase64.split(';base64,')[1];
        }

        cleanBase64 = cleanBase64.replaceAll(RegExp(r'\s+'), '');

        int padLength = 4 - (cleanBase64.length % 4);
        if (padLength < 4) {
          cleanBase64 += '=' * padLength;
        }

        final bytes = base64Decode(cleanBase64);
        _decodedImage = Image.memory(
          bytes,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('Error displaying image: $error');
            return const Icon(Icons.error);
          },
        );
      } catch (e) {
        print('Error decoding image: $e');
      }
    }
  }

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['berita_id'] ?? 0,
      title: json['judul_berita'] ?? '',
      date: json['tgl_berita'] ?? '',
      imageBase64: json['foto_berita']?.toString() ?? '',
    );
  }
}

class _HomeState extends State<Home> {
  List<NewsModel> news = [];
  bool isLoading = true;
  String userName = 'User';
  Image? profileImage;

  String _getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 11) {
      return 'Selamat Pagi';
    } else if (hour < 15) {
      return 'Selamat Siang';
    } else if (hour < 19) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNews();
    fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId == null) {
        print('User ID not found in SharedPreferences');
        return;
      }

      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}user-profile/$userId'),
        headers: {'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'success' &&
            responseData['data'] != null) {
          setState(() {
            userName = responseData['data']['nama'] ?? 'User';
            if (responseData['data']['foto_profil'] != null) {
              _decodeProfileImage(responseData['data']['foto_profil']);
            }
          });
        } else {
          print('Invalid response format or missing data');
        }
      } else if (response.statusCode == 404) {
        print('User not found');
      } else {
        print('Failed to fetch user profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
    }
  }

  void _decodeProfileImage(String? base64String) {
    if (base64String == null || base64String.isEmpty) {
      return;
    }

    try {
      String cleanBase64 = base64String.trim();

      // Remove data URI prefix if present
      if (cleanBase64.contains(';base64,')) {
        cleanBase64 = cleanBase64.split(';base64,')[1];
      }

      // Remove any whitespace
      cleanBase64 = cleanBase64.replaceAll(RegExp(r'\s+'), '');

      // Add padding if necessary
      int padLength = 4 - (cleanBase64.length % 4);
      if (padLength < 4) {
        cleanBase64 += '=' * padLength;
      }

      final bytes = base64Decode(cleanBase64);
      setState(() {
        profileImage = Image.memory(
          bytes,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            print('Error displaying profile image: $error');
            return const Icon(Icons.person);
          },
        );
      });
    } catch (e) {
      print('Error decoding profile image: $e');
    }
  }

  Future<void> fetchNews() async {
    try {
      final response =
          await http.get(Uri.parse('${ApiConfig.baseUrl}berita-dashboard'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> newsData = responseData['data'];

        setState(() {
          news = newsData.map((item) => NewsModel.fromJson(item)).toList();
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        throw Exception('Failed to load news');
      }
    } catch (e) {
      setState(() => isLoading = false);
      print('Error fetching news: $e');
    }
  }

  Widget _buildProfileSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hi $userName!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  _getGreeting(),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilPage()),
              );
            },
            child: Hero(
              tag: 'profilePhoto',
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.cyan.withOpacity(0.5),
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyan.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage:
                          profileImage != null ? profileImage!.image : null,
                      child: profileImage == null
                          ? const Icon(Icons.person, size: 40)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 16,
                        child:
                            Icon(Icons.edit, color: Colors.blue[600], size: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItem(NewsModel newsItem) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
              child: AspectRatio(
                aspectRatio: 21 / 9,
                child: newsItem.decodedImage ??
                    Container(
                      color: const Color(0xFF1068BB),
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Color(0xFF1068BB),
                          size: 60,
                        ),
                      ),
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    newsItem.date,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    newsItem.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1068BB),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigasi ke DetailBerita dengan ID berita
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailBerita(id: newsItem.id),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1068BB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Lihat Selengkapnya',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: HeaderClipper(),
                child: Container(
                  color: const Color(0xff1068BB),
                  padding: const EdgeInsets.symmetric(
                    vertical: 90.0,
                    horizontal: 16.0,
                  ),
                  child: _buildProfileSection(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildGridButton('Peraturan\nPresiden',
                        'assets/icons/PeraturanPresiden.png', context),
                    _buildGridButton('Peraturan\nMentri',
                        'assets/icons/PeraturanMentri.png', context),
                    _buildGridButton('Peraturan\nBNPP',
                        'assets/icons/bnpplogo.png', context),
                    _buildGridButton(
                        'Paparan', 'assets/icons/Presentasi2.png', context),
                    _buildGridButton('Panduan\nPengguna',
                        'assets/icons/Panduan.png', context),
                    _buildGridButton(
                        'Lainnya', 'assets/icons/Others.png', context),
                  ],
                ),
              ),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : news.isEmpty
                      ? const EmptyNewsState()
                      : Column(
                          children:
                              news.map((item) => _buildNewsItem(item)).toList(),
                        ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridButton(
      String label, String imagePath, BuildContext context) {
    return InkWell(
      onTap: () {
        switch (label) {
          case 'Peraturan\nPresiden':
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => const ListPeraturanPresiden()),
            // );
            break;
          case 'Peraturan\nMentri':
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => const ListPeraturanMentri()),
            // );
            break;
          case 'Peraturan\nBNPP':
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => const ListPeraturanBnpp()),
            // );
            break;
          case 'Paparan':
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const ListPaparan()),
            // );
            break;
          case 'Panduan\nPengguna':
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => NotificationsScreen()),
            // );
            break;
          case 'Lainnya':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MainMenu()),
            );
            break;
          default:
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize:
              MainAxisSize.min, // Tambahkan ini untuk membatasi ukuran kolom
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1068BB).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                imagePath,
                width: 40,
                height: 40,
              ),
            ),
            const SizedBox(height: 8), // Kurangi jarak antara gambar dan teks
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2, // Batasi maksimal 2 baris
                overflow: TextOverflow
                    .ellipsis, // Tambahkan ellipsis jika teks terlalu panjang
                style: const TextStyle(
                  fontSize: 11, // Kurangi ukuran font sedikit
                  color: Color(0xFF1068BB),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EmptyNewsState extends StatelessWidget {
  const EmptyNewsState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/nonews.png', // Make sure to add this image to your assets
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          const Text(
            'Tidak ada berita terbaru',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Silakan cek kembali nanti untuk pembaruan berita',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }
}

class HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);

    var controlPoint = Offset(size.width / 2, size.height + 40);
    var endPoint = Offset(size.width, size.height - 50);

    path.quadraticBezierTo(
        controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
