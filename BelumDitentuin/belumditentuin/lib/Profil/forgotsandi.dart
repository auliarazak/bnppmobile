import 'package:flutter/material.dart';

class forgotpassword extends StatefulWidget {
  const forgotpassword({super.key});

  @override
  State<forgotpassword> createState() => _forgotpasswordState();
}

class _forgotpasswordState extends State<forgotpassword> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        backgroundColor: const Color(0xFF1068BB),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Lupa Kata Sandi',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),
            Image.asset(
              'lib/images/forgotpsw.png', // Tambahkan gambar ilustrasi di folder assets
              height: 200,
            ),
            SizedBox(height: 20),
            // Text dengan shadow
            Text(
              'Reset Kata Sandi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Warna coklat
                shadows: [
                  Shadow(
                    blurRadius: 3.0,
                    color: Colors.black.withOpacity(0.5),
                    offset: Offset(3, 3),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Masukkan email yang berhubungan dengan akunmu dan kami akan mengirimkan untuk mengatur ulang kata sandimu',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            // TextField dengan border warna biru
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: 'Email',
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                border: OutlineInputBorder(
                   borderSide: BorderSide(
                    color: Color(0xff0000ff), // Border warna biru
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Tombol dengan border background biru
            ElevatedButton(
              onPressed: () {
                // Aksi ketika tombol ditekan
              },
              child: Text('Konfirmasi Email'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(
                    color: Color(0xff0000ff), // Border warna biru

                  ),
                ),
                backgroundColor: Color(0xff1068BB), // Background putih
                foregroundColor: Color(0xffffffff), 
                 minimumSize: const Size(200, 55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
