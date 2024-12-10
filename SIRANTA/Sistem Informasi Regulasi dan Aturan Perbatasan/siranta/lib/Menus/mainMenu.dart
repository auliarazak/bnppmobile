import 'package:flutter/material.dart';
import 'package:siranta/Menus/sub_mainmenu.dart'; // Pastikan import file SubMenu

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final List<Map<String, String>> menuItems = [
    {
      'title': 'Kebijakan Pengelolaan \nPerbatasan Negara',
      'image': 'assets/images/MenuPeraturan.jpg',
      'type': 'left'
    },
    {
      'title': 'Paparan dan Surat Penting',
      'image': 'assets/images/MenuPaparan.jpg',
      'type': 'right'
    },
    {
      'title': 'Produk Setup BNPP',
      'image': 'assets/images/MenuProduk.jpg',
      'type': 'left'
    },
    {
      'title': 'Berita',
      'image': 'assets/images/MenuBerita.jpg',
      'type': 'right'
    },
    {
      'title': 'Pengaturan Data',
      'image': 'assets/images/MenuManajemen.jpg',
      'type': 'left'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.blue.shade50,
            pinned: true,
            floating: false,
            expandedHeight: 70.0,
            collapsedHeight: 56.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Menu',
                style: TextStyle(
                  fontFamily: "Plus Jakarta Sans",
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth < 360 ? 24 : 30,
                  color: Colors.blue.shade900,
                ),
                textScaler: TextScaler.linear(screenWidth < 360 ? 0.7 : 1.0),
              ),
              centerTitle: true,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = menuItems[index];
                  return _buildAnimatedMenuItem(
                    context,
                    title: item['title']!,
                    imageUrl: item['image']!,
                    isLeft: item['type'] == 'left',
                    delay: index * 200,
                    screenWidth: screenWidth,
                  );
                },
                childCount: menuItems.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedMenuItem(
    BuildContext context, {
    required String title,
    required String imageUrl,
    required bool isLeft,
    required int delay,
    required double screenWidth,
  }) {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 800),
      tween: Tween<double>(begin: 0, end: 1),
      curve: Curves.easeOutQuint,
      builder: (context, opacity, child) {
        return Transform.translate(
          offset: Offset(opacity * (isLeft ? -20 : 20), 0),
          child: Opacity(
            opacity: opacity,
            child: _buildMenuItem(
              context,
              title: title,
              imageUrl: imageUrl,
              isLeft: isLeft,
              screenWidth: screenWidth,
            ),
          ),
        );
      },
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String title,
    required String imageUrl,
    required bool isLeft,
    required double screenWidth,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => SubMenu(
              backgroundImage: imageUrl,
              menuTitle: title,
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              final tween = Tween(begin: begin, end: end);
              final offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: imageUrl,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.asset(
                      imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              // Overlay gradien
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.2),
                      ],
                    ),
                  ),
                ),
              ),

              // Posisi teks
              Positioned(
                bottom: 20,
                left: isLeft ? 20 : null,
                right: !isLeft ? 20 : null,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth < 360 ? 16 : 20.0,
                    fontWeight: FontWeight.bold,
                    shadows: const [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}