import 'package:belumditentuin/Layanan/layanan.dart';
import 'package:belumditentuin/Peraturan/list.dart';
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
      body: Stack(
        children: [
          // Menambahkan CustomPaint dengan RPSCustomPainter sebagai background
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width,
                MediaQuery.of(context).size.height),
            painter: RPSCustomPainter(),
          ),
          // Konten utama aplikasi ditempatkan di atas background
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      Positioned(
                        right: 10,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          width: 50,
                          height: 50,
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                'https://static.vecteezy.com/system/resources/previews/005/129/844/non_2x/profile-user-icon-isolated-on-white-background-eps10-free-vector.jpg'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: const Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        "Hi Users",
                                        style: TextStyle(
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          color: const Color.fromARGB(
                                              255, 33, 150, 243),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Good Morning!",
                                        style: TextStyle(
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontWeight: FontWeight.w300,
                                          fontSize: 12.0,
                                          color: const Color.fromARGB(
                                              255, 33, 150, 243),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: Column(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                    child: Image.asset(
                                                      'lib/images/PeraturanPresiden.png',
                                                      fit: BoxFit.cover,
                                                      width: 60,
                                                      height: 60,
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Peraturan Presiden",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Plus Jakarta Sans',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 33, 150, 243)),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 1),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ListPeraturan()),
                                            );
                                          },
                                          child: Container(
                                            child: Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Column(
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  20)),
                                                      child: Image.asset(
                                                        'lib/images/PeraturanMentri.png',
                                                        fit: BoxFit.cover,
                                                        width: 60,
                                                        height: 60,
                                                      ),
                                                    ),
                                                    const Text(
                                                      "Peraturan Mentri",
                                                      style: TextStyle(
                                                        fontFamily:
                                                            'Plus Jakarta Sans',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 33, 150, 243),
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    SizedBox(height: 1),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: Column(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                    child: Image.asset(
                                                      'lib/images/PeraturanBnpp.png',
                                                      fit: BoxFit.cover,
                                                      width: 60,
                                                      height: 60,
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Peraturan BNPP",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Plus Jakarta Sans',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 33, 150, 243)),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(height: 1),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: Column(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                    child: Image.asset(
                                                      'lib/images/Peraturan.png',
                                                      fit: BoxFit.cover,
                                                      width: 60,
                                                      height: 60,
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Peraturan A",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Plus Jakarta Sans',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 33, 150, 243)),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(height: 1),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          child: Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: Column(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                20)),
                                                    child: Image.asset(
                                                      'lib/images/Peraturan2.png',
                                                      fit: BoxFit.cover,
                                                      width: 60,
                                                      height: 60,
                                                    ),
                                                  ),
                                                  const Text(
                                                    "Peraturan B",
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'Plus Jakarta Sans',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 33, 150, 243)),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  SizedBox(height: 1),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const Layanan(), // Navigasi ke halaman Layanan
                                              ),
                                            );
                                          },
                                          child: Container(
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Column(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Color.fromARGB(255, 224, 227, 230)
                                                                .withOpacity(
                                                                    0.3),
                                                            spreadRadius: 2,
                                                            blurRadius: 5,
                                                            offset:
                                                                const Offset(
                                                                    0, 3),
                                                          ),
                                                        ],
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                                Radius.circular(
                                                                    0)),
                                                        child: Image.asset(
                                                          'lib/images/Others.png',
                                                          fit: BoxFit.cover,
                                                          width: 60,
                                                          height: 60,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    const Text(
                                                      "Lainnya",
                                                      style: TextStyle(
                                                          fontFamily:
                                                              'Plus Jakarta Sans',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14,
                                                          color: const Color
                                                              .fromARGB(255, 33,
                                                              150, 243)),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  'https://i.pinimg.com/564x/0e/22/4c/0e224cd4865bef54aeb1f4cc110b78dd.jpg',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 100,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Text(
                                  'Tanggal: ${DateTime.now().add(Duration(days: index)).toLocal().toString().split(' ')[0]}',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                  'Judul Berita ${index + 1}',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Text(
                                  'Lihat selengkapnya',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Background curve menggunakan RPSCustomPainter
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Layer 1
    Paint paint_fill_0 = Paint()
      ..color = Color.fromARGB(255, 16, 104, 187)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_0 = Path();
    path_0.moveTo(0, 0);
    path_0.quadraticBezierTo(size.width * 0.7500000, 0, size.width, 0);
    path_0.lineTo(size.width, size.height);
    path_0.lineTo(size.width * -0.0013889, size.height);
    path_0.lineTo(size.width * -0.0014028, size.height * 0.7671875);
    path_0.quadraticBezierTo(size.width * 0.0631944, size.height * 0.7159297,
        size.width * 0.2784583, size.height * 0.7029141);
    path_0.quadraticBezierTo(size.width * 1.0005556, size.height * 0.6671719,
        size.width * 0.9986111, size.height * 0.3460937);
    path_0.quadraticBezierTo(
        size.width * 0.9329861, size.height * 0.0420937, 0, 0);
    path_0.close();

    canvas.drawPath(path_0, paint_fill_0);

    // Layer 1 stroke (opsional, jika diperlukan)
    Paint paint_stroke_0 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(path_0, paint_stroke_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
