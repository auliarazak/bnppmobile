// import 'dart:ui';

// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';

// class CustomButton extends StatelessWidget {
//   final VoidCallback? onPressed;
//   final String text;
//   final String imagePath;
//   final Color primaryColor;

//   const CustomButton({
//     Key? key,
//     required this.onPressed,
//     required this.text,
//     required this.imagePath,
//     this.primaryColor = Colors.blue,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onPressed,
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [
//               Colors.white.withOpacity(0.7),
//               primaryColor.withOpacity(0.3),
//             ],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(20.0),
//           boxShadow: [
//             BoxShadow(
//               color: primaryColor.withOpacity(0.4),
//               spreadRadius: 2,
//               blurRadius: 12,
//               offset: const Offset(0, 6),
//             ),
//           ],
//           border: Border.all(
//             color: Colors.white.withOpacity(0.5),
//             width: 1.5,
//           ),
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(20.0),
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 20.0,
//                 vertical: 16.0,
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Warm-toned Glowing Image
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(15),
//                       boxShadow: [
//                         BoxShadow(
//                           color: primaryColor.withOpacity(0.4),
//                           spreadRadius: 2,
//                           blurRadius: 10,
//                         )
//                       ],
//                     ),
//                     child: Image.asset(
//                       imagePath, 
//                       width: 50, 
//                       height: 50,
                    
//                       colorBlendMode: BlendMode.srcIn,
//                     ),
//                   ),
//                   const SizedBox(width: 16.0),
//                   // Soft Text
//                   Text(
//                     text,
//                     style: TextStyle(
//                       fontSize: 20.0,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.brown.shade800,
//                       shadows: [
//                         Shadow(
//                           blurRadius: 5.0,
//                           color: Colors.white.withOpacity(0.5),
//                           offset: const Offset(1, 1),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// class PengaturanPeraturan extends StatefulWidget {
//   const PengaturanPeraturan({super.key});

//   @override
//   State<PengaturanPeraturan> createState() => _PengaturanPeraturanState();
// }

// class _PengaturanPeraturanState extends State<PengaturanPeraturan> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 248, 206, 191), // Dark futuristic background
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               CustomButton(
//                 onPressed: () {
//                   // Add your button press logic here
//                 },
//                 imagePath: "assets/icons/Edit4.png",
//                 text: 'Tambah Peraturan \nBaru',
//                 primaryColor: Colors.cyan,
//               ),
//               const SizedBox(height: 24),
//               CustomButton(
//                 onPressed: () {
//                   // Add your button press logic here
//                 },
//                 imagePath: "assets/icons/Create4.png",
//                 text: 'Edit Peraturan',
//                 primaryColor: Colors.deepPurple,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }