import 'package:belumditentuin/LoginScreen/loginscreen.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // List of images, titles, and descriptions
  final List<Map<String, String>> contentList = [
    {
      'image': 'lib/images/PLBN_Aruk.png',
      'title': 'PLBN ARUK',
      'description':
          'PLBN Aruk adalah pintu perbatasan antara Indonesia dan Malaysia, mendukung arus barang dan orang serta pertumbuhan ekonomi lokal.'
    },
    {
      'image': 'lib/images/PLBN_Badau.png',
      'title': 'PLBN BADAU',
      'description':
          'PLBN Badau terletak di Kalimantan Barat, Indonesia, dan berfungsi sebagai pintu gerbang perbatasan dengan Malaysia.'
    },
    {
      'image': 'lib/images/PLBN_Entikong.png',
      'title': 'PLBN ENTIKONG',
      'description':
          'PLBN Entikong adalah pusat perbatasan Indonesia-Malaysia, mendukung perdagangan antarnegara serta arus barang dan orang.'
    },
    {
      'image': 'lib/images/PLBN_Jagoibabang.png',
      'title': 'PLBN JAGOIBABANG',
      'description':
          'PLBN Jagoibabang adalah pos perbatasan Indonesia-Malaysia di Kalimantan Barat yang memfasilitasi arus barang dan manusia.'
    },
    {
      'image': 'lib/images/PLBN_Motaain.png',
      'title': 'PLBN MOTAAIN',
      'description':
          'PLBN Motaain terletak di perbatasan Indonesia-Timor Leste, mendukung mobilitas orang dan barang serta hubungan ekonomi.'
    },
    {
      'image': 'lib/images/PLBN_Motamasin2.png',
      'title': 'PLBN MOTAMASIN',
      'description':
          'PLBN Motamasin adalah pintu gerbang perbatasan antara Indonesia dan Timor Leste, mendukung perdagangan dan arus orang.'
    },
    {
      'image': 'lib/images/PLBN_Serasan.png',
      'title': 'PLBN SERASAN',
      'description':
          'PLBN Serasan merupakan pos perbatasan yang terletak di Kepulauan Riau, mendukung hubungan antar negara tetangga.'
    },
    {
      'image': 'lib/images/PLBN_Skouw.png',
      'title': 'PLBN SKOUW',
      'description':
          'PLBN Skouw adalah pintu perbatasan Indonesia-Papua Nugini, mendukung ekonomi lokal dengan arus barang dan orang.'
    },
    {
      'image': 'lib/images/PLBN_Sota.png',
      'title': 'PLBN SOTA',
      'description':
          'PLBN Sota terletak di perbatasan Papua dengan Papua Nugini, mendukung interaksi ekonomi dan sosial antarnegara.'
    },
    {
      'image': 'lib/images/PLBN_Wini.png',
      'title': 'PLBN WINI',
      'description':
          'PLBN Wini terletak di perbatasan Indonesia dengan Timor Leste, memfasilitasi perdagangan dan interaksi lintas batas.'
    },
    {
      'image': 'lib/images/PLBN_Yatetkun.png',
      'title': 'PLBN YATETKUN',
      'description':
          'PLBN Yatetkun adalah pintu perbatasan di Papua yang memfasilitasi perdagangan dan mobilitas antarnegara tetangga.'
    },
  ];

  int currentIndex = 0;
  bool isAnimating = false;

  void _nextContent() {
    setState(() {
      isAnimating = true;
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() {
          currentIndex = (currentIndex + 1) % contentList.length;
          isAnimating = false;
        });
      });
    });
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      width: isActive ? 25 : 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1068BB) : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05, vertical: screenHeight * 0.05),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),

                // Responsive image container
                AnimatedOpacity(
                  opacity: isAnimating ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    width: double.infinity,
                    height: screenHeight *
                        0.4, // Use height as a fraction of the screen height
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(contentList[currentIndex]['image']!),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // Title with animation
                AnimatedOpacity(
                  opacity: isAnimating ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Text(
                      contentList[currentIndex]['title']!,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: screenWidth * 0.06, // Responsive font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Description with animation
                AnimatedOpacity(
                  opacity: isAnimating ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    child: Text(
                      contentList[currentIndex]['description']!,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: screenWidth * 0.04, // Responsive font size
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Bottom buttons and indicators
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                    left: screenWidth * 0.05,
                    right: screenWidth * 0.05,
                    bottom: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Indicator dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(contentList.length, (index) {
                        return _buildIndicator(index == currentIndex);
                      }),
                    ),
                    const SizedBox(height: 20),

                    // Bottom buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Skip button without background
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                'Lewati',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  color: const Color(0xFF1068BB),
                                  fontSize: screenWidth *
                                      0.04, // Responsive font size
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Icon(
                                Icons.arrow_forward,
                                color: const Color(0xFF1068BB),
                              ),
                            ],
                          ),
                        ),

                        // Next button with blue background
                        ElevatedButton(
                          onPressed: _nextContent,
                          child: const Text('Selanjutnya'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1068BB),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.1, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
