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
      'image': 'lib/images/plbnAruk.png',
      'title': 'PLBN ARUK',
      'description': 'PLBN Aruk adalah pintu perbatasan Indonesia-Malaysia yang memfasilitasi arus barang dan orang, mendukung pertumbuhan ekonomi lokal.'
    },
    {
      'image': 'lib/images/plbnEntikong.png',
      'title': 'PLBN ENTIKONG',
      'description': 'PLBN Entikong adalah Pusat Layanan Border Nasional di perbatasan Indonesia-Malaysia, Kabupaten Sanggau, Kalimantan Barat. Fasilitas ini mendukung arus barang dan orang serta meningkatkan kerjasama ekonomi antarnegara.'
    },
    {
      'image': 'lib/images/plbnSkouw.png',
      'title': 'PLBN SKOUW',
      'description': 'PLBN Skouw adalah pintu perbatasan Indonesia-Papua Nugini yang mendukung arus barang, orang, dan pertumbuhan ekonomi lokal.'
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
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.05),
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
                    height: screenHeight * 0.4, // Use height as a fraction of the screen height
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                padding: EdgeInsets.only(left: screenWidth * 0.05, right: screenWidth * 0.05, bottom: 30),
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
                                  fontSize: screenWidth * 0.04, // Responsive font size
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
                            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: 15),
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
