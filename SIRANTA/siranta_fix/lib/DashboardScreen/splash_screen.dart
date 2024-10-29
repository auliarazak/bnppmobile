import 'package:flutter/material.dart';
import 'package:siranta_fix/DashboardScreen/dashboard.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _backgroundController;
  late Animation<double> _logoAnimation;
  late Animation<Offset> _textAnimationLeft;
  late Animation<Offset> _textAnimationRight;
  late Animation<Color?> _textColorAnimation;
  late Animation<double> _circleSizeAnimation;
  Color _backgroundColor = Colors.blue[600]!;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _textController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeInOut,
    );

    _textAnimationLeft = Tween<Offset>(
      begin: Offset(-2.0, 0.0),
      end: Offset(0.05, 0.0),
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    _textAnimationRight = Tween<Offset>(
      begin: Offset(2.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    _circleSizeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _textColorAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.blue[600],
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    ));

    _logoController.forward().then((_) {
      _textController.forward().then((_) {
        Future.delayed(Duration(milliseconds: 10), () {
          _backgroundController.forward().then((_) {
            setState(() {
              _backgroundColor = Colors.white;
            });
            Future.delayed(Duration(seconds: 1), () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              );
            });
          });
        });
      });
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _circleSizeAnimation,
            builder: (context, child) {
              double size = MediaQuery.of(context).size.width *
                  _circleSizeAnimation.value;

              return Container(
                decoration: BoxDecoration(
                  color: _backgroundColor,
                ),
                child: Center(
                  child: Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            },
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _logoAnimation,
                  child: Image.asset(
                    'assets/images/BnppLogo.png',
                    height: 200,
                    width: 200,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SlideTransition(
                      position: _textAnimationLeft,
                      child: AnimatedBuilder(
                        animation: _textColorAnimation,
                        builder: (context, child) {
                          return Text(
                            'Badan Nasional',
                            style: TextStyle(
                              color: _textColorAnimation.value,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    SlideTransition(
                      position: _textAnimationRight,
                      child: AnimatedBuilder(
                        animation: _textColorAnimation,
                        builder: (context, child) {
                          return Text(
                            'Pengelola Perbatasan',
                            style: TextStyle(
                              color: _textColorAnimation.value,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
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
