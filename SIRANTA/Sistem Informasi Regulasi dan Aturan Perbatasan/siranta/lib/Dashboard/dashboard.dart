import 'package:flutter/material.dart';
import 'package:siranta/Login/login_screen.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin {
  final List<Map<String, String>> contentList = [
    {
      'image': 'assets/images/plbns/PLBN_Aruk.png',
      'title': 'PLBN ARUK',
      'description':
          'PLBN Aruk adalah pintu perbatasan antara Indonesia dan Malaysia, mendukung arus barang dan orang serta pertumbuhan ekonomi lokal.'
    },
    {
      'image': 'assets/images/plbns/PLBN_Badau.png',
      'title': 'PLBN BADAU',
      'description':
          'PLBN Badau terletak di Kalimantan Barat, Indonesia, dan berfungsi sebagai pintu gerbang perbatasan dengan Malaysia.'
    },
    {
      'image': 'assets/images/plbns/PLBN_Entikong.png',
      'title': 'PLBN ENTIKONG',
      'description':
          'PLBN Entikong adalah pusat perbatasan Indonesia-Malaysia, mendukung perdagangan antarnegara serta arus barang dan orang.'
    },
    {
      'image': 'assets/images/plbns/PLBN_Jagoibabang.png',
      'title': 'PLBN JAGOIBABANG',
      'description':
          'PLBN Jagoibabang adalah pos perbatasan Indonesia-Malaysia di Kalimantan Barat yang memfasilitasi arus barang dan manusia.'
    },
    {
      'image': 'assets/images/plbns/PLBN_Motaain.png',
      'title': 'PLBN MOTAAIN',
      'description':
          'PLBN Motaain terletak di perbatasan Indonesia-Timor Leste, mendukung mobilitas orang dan barang serta hubungan ekonomi.'
    },
    {
      'image': 'assets/images/plbns/PLBN_Motamasin.png',
      'title': 'PLBN MOTAMASIN',
      'description':
          'PLBN Motamasin adalah pintu gerbang perbatasan antara Indonesia dan Timor Leste, mendukung perdagangan dan arus orang.'
    },
    {
      'image': 'assets/images/plbns/PLBN_Serasan.png',
      'title': 'PLBN SERASAN',
      'description':
          'PLBN Serasan merupakan pos perbatasan yang terletak di Kepulauan Riau, mendukung hubungan antar negara tetangga.'
    },
    {
      'image': 'assets/images/plbns/PLBN_Skouw.png',
      'title': 'PLBN SKOUW',
      'description':
          'PLBN Skouw adalah pintu perbatasan Indonesia-Papua Nugini, mendukung ekonomi lokal dengan arus barang dan orang.'
    },
    {
      'image': 'assets/images/plbns/PLBN_Sota.png',
      'title': 'PLBN SOTA',
      'description':
          'PLBN Sota terletak di perbatasan Papua dengan Papua Nugini, mendukung interaksi ekonomi dan sosial antarnegara.'
    },
    {
      'image': 'assets/images/plbns/PLBN_Wini.png',
      'title': 'PLBN WINI',
      'description':
          'PLBN Wini terletak di perbatasan Indonesia dengan Timor Leste, memfasilitasi perdagangan dan interaksi lintas batas.'
    },
    {
      'image': 'assets/images/plbns/PLBN_Yatetkun.png',
      'title': 'PLBN YATETKUN',
      'description':
          'PLBN Yatetkun adalah pintu perbatasan di Papua yang memfasilitasi perdagangan dan mobilitas antarnegara tetangga.'
    },
  ];

  int currentIndex = 0;
  bool isAnimating = false;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _nextContent() {
    _animationController.forward(from: 0);
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
    width: isActive ? 35 : 12,
    height: 12,
    decoration: BoxDecoration(
      color: isActive ? const Color(0xFF1068BB) : Colors.grey.shade400,
      borderRadius: BorderRadius.circular(10),
      boxShadow: isActive 
        ? [
            BoxShadow(
              color: const Color(0xFF1068BB).withOpacity(0.5),
              blurRadius: 8.0,
              spreadRadius: 2.0,
              offset: const Offset(0, 2),
            )
          ]
        : [],
    ),
  ).animate(
    effects: [
      const FadeEffect(duration: Duration(milliseconds: 300)),
      const ScaleEffect(
        begin: Offset(0.8, 0.8), // Setara dengan skala 0.8
        end: Offset(1.0, 1.0),   // Setara dengan skala 1.0
      ),  // Ensure that you are passing doubles for scaling
    ],
  );
}


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blue.shade50,
                  Colors.blue.shade100,
                ],
              ),
            ),
          ),

          // Main Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, 
              vertical: screenHeight * 0.04
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // Animated Image Container
                Hero(
                  tag: 'plbn-image',
                  child: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: 1 - (_animationController.value * 0.1),
                        child: Container(
                          width: double.infinity,
                          height: screenHeight * 0.4,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(contentList[currentIndex]['image']!),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 15,
                                offset: const Offset(0, 10),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ).animate(
                  effects: [
                    FadeEffect(duration: Duration(milliseconds: 500)),
                    SlideEffect(
                      begin: Offset(0, 0.2),
                      end: Offset.zero,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Animated Title
                Text(
                  contentList[currentIndex]['title']!,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: screenWidth * 0.06,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1068BB),
                  ),
                ).animate(
                  effects: [
                    FadeEffect(duration: Duration(milliseconds: 500)),
                    SlideEffect(
                      begin: Offset(-0.2, 0),
                      end: Offset.zero,
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Animated Description
                Text(
                  contentList[currentIndex]['description']!,
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: screenWidth * 0.04,
                    color: Colors.grey.shade700,
                  ),
                ).animate(
                  effects: [
                    FadeEffect(duration: Duration(milliseconds: 500)),
                    SlideEffect(
                      begin: Offset(0.2, 0),
                      end: Offset.zero,
                    ),
                  ],
                ),

                const Spacer(),

                // Bottom Section
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Indicator Dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(contentList.length, (index) {
                        return _buildIndicator(index == currentIndex);
                      }),
                    ),
                    const SizedBox(height: 20),

                    // Navigation Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Skip Button
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
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 5),
                              const Icon(
                                Icons.arrow_forward,
                                color: Color(0xFF1068BB),
                              ),
                            ],
                          ),
                        ).animate(
                          effects: [
                            FadeEffect(duration: Duration(milliseconds: 500)),
                            SlideEffect(
                              begin: Offset(-0.2, 0),
                              end: Offset.zero,
                            ),
                          ],
                        ),

                        // Next Button
                        ElevatedButton(
                          onPressed: _nextContent,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1068BB),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.1, 
                              vertical: 15
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 6,
                          ),
                          child: const Text('Selanjutnya'),
                        ).animate(
                          effects: [
                            FadeEffect(duration: Duration(milliseconds: 500)),
                            SlideEffect(
                              begin: Offset(0.2, 0),
                              end: Offset.zero,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
