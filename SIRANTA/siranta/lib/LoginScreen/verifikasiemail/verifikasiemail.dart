import 'package:flutter/material.dart';

class VerifikasiEmail extends StatefulWidget {
  const VerifikasiEmail({super.key});

  @override
  State<VerifikasiEmail> createState() => _VerifikasiEmailState();
}

class _VerifikasiEmailState extends State<VerifikasiEmail> {
  // Customizable parameters
  Color borderColor = Colors.blue; // Border color
  double borderWidth = 2.0; // Border width
  Color confirmationTextColor = Colors.white; // Confirmation button text color

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 50, bottom: 30),
              child: Center(
                child: Image.asset(
                  'assets/images/cuate.png',
                  height: 300,
                ),
              ),
            ),
            Text(
              "Masukkan Kode Verifikasi",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.brown,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Kode Verifikasi dikirim ke\nlibryanadetya23009@gmail.com",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCodeInputField(),
                _buildCodeInputField(),
                _buildCodeInputField(),
                _buildCodeInputField(),
              ],
            ),
            const SizedBox(height: 30),
            
           ElevatedButton(
  onPressed: () {
    // Action when the button is pressed
  },
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), // Mengatur sudut kotak menjadi lebih membulat
      side: BorderSide(
        color: borderColor, // Warna border yang dapat diatur
        width: borderWidth, // Ukuran border yang dapat diatur
      ),
    ),
    backgroundColor: Colors.blue, 
     minimumSize: const Size(200, 55),// Warna latar belakang tombol
  ),
  child: Text(
    "Konfirmasi Kode",
    style: TextStyle(
      fontSize: 16,
      color: confirmationTextColor, // Warna teks yang dapat diatur
    ),
  ),
),
 // Use the customizable text color
          ],
        ),
      ),
    );
  }

  Widget _buildCodeInputField() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2), // Border color and width
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        style: const TextStyle(fontSize: 18),
        maxLength: 1, 
        decoration: const InputDecoration(
          counterText: "", 
          border: InputBorder.none,
        ),
      ),
    );
  }
}
