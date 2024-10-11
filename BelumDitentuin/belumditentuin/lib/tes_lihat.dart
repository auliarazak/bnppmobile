import 'package:flutter/material.dart';

class CurvedBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomPaint(
            painter: RPSCustomPainter(),
            child: Container(),
          ),
          // Content of your app here (e.g., the helicopter cards)
          Center(
            child: Column(
              children: [
                SizedBox(height: 100),
                Text("Explore our fleet", style: TextStyle(fontSize: 24)),
                // Add other widgets here, like your cards.
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter{
  
  @override
  void paint(Canvas canvas, Size size) {
    
    

  // Layer 1
  
  Paint paint_fill_0 = Paint()
      ..color = Color.fromARGB(255, 16, 104, 187)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
     
         
    Path path_0 = Path();
    path_0.moveTo(0,0);
    path_0.quadraticBezierTo(size.width*0.7500000,0,size.width,0);
    path_0.lineTo(size.width,size.height);
    path_0.lineTo(size.width*-0.0013889,size.height);
    path_0.lineTo(size.width*-0.0014028,size.height*0.7671875);
    path_0.quadraticBezierTo(size.width*0.0631944,size.height*0.7159297,size.width*0.2784583,size.height*0.7029141);
    path_0.quadraticBezierTo(size.width*1.0005556,size.height*0.6671719,size.width*0.9986111,size.height*0.3460937);
    path_0.quadraticBezierTo(size.width*0.9329861,size.height*0.0420937,0,0);
    path_0.close();

    canvas.drawPath(path_0, paint_fill_0);
  

  // Layer 1
  
  Paint paint_stroke_0 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width*0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;
     
         
    
    canvas.drawPath(path_0, paint_stroke_0);
  
    
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}


