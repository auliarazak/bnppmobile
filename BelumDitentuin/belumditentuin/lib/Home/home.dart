import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
                  color: Color(0xff1068BB), 
                  padding: EdgeInsets.symmetric(vertical: 90.0, horizontal: 16.0), 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center, 
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0, left: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hi Libryan!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Good Morning',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildGridButton('UU', 'lib/images/undangundang.png'),
                    _buildGridButton('Peraturan\nPemerintah', 'lib/images/peraturanpemerintah.png'),
                    _buildGridButton('Peraturan\nPresiden', 'lib/images/peraturanpresiden.png'),
                    _buildGridButton('Peraturan\nBNPP', 'lib/images/peraturanbnpp.png'),
                    _buildGridButton('Peraturan\nKementrian', 'lib/images/peraturankementrian.png'),
                    _buildGridButton('More', 'lib/images/More.png'), 
                  ],
                ),
              ),

              _buildNewsItem(
                'Proses Pembangunan PLBN Napan',
                '16 Aug 2022, 15:02',
              ),
              _buildNewsItem(
                'Proses Pembangunan PLBN Napan',
                '16 Aug 2022, 15:02',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridButton(String label, String imagePath) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            shape: BoxShape.circle,
          ),
          child: Image.asset(
            imagePath,
            width: 32,
            height: 32,
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildNewsItem(String title, String timestamp) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            height: 150,
            color: Colors.grey[300],
          ),
          SizedBox(height: 8),
          Text(
            timestamp,
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          TextButton(
            onPressed: () {},
            child: Text('Lihat Selengkapnya'),
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
    path.lineTo(0, size.height - 70); 

    var controlPoint = Offset(size.width / 2, size.height + 60); 
    var endPoint = Offset(size.width, size.height - 70);

    path.quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}