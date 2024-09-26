import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Bagian atas dengan background gradien
          Container(
            height:
                MediaQuery.of(context).size.height * 0.57, // Dikurangi sedikit
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 6, 82, 153),
                  Colors.white
                ], // Gradien dari #1068BB ke putih
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0), // Padding around the content
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Foto Profil
                  Align(
                    alignment: Alignment.topRight,
                    child: CircleAvatar(
                      radius: 30, // Ukuran gambar melingkar
                      backgroundImage: AssetImage(
                          'lib/images/profile_picture.png'), // Ganti dengan path gambar profil
                    ),
                  ),
                  const SizedBox(height: 10), // Spasi antara profil dan teks
                  // Nama Pengguna
                  const Text(
                    'Hi Libryan!',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                      height: 5), // Spasi antara nama pengguna dan good morning
                  // Good Morning
                  const Text(
                    'Good Morning',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                      height: 10), // Spasi antara teks dan search bar
                  // Search Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, color: Colors.red),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                      height: 15), // Jarak antara search bar dan button persegi
                  // 6 Button Persegi
                  Flexible(
                    child: Card(
                      color: Colors.white, // Warna latar belakang card
                      elevation: 3, // Tambahkan bayangan jika diinginkan
                      child: Padding(
                        padding: const EdgeInsets.all(
                            10.0), // Padding 10px dari tepi
                        child: GridView.count(
                          crossAxisCount: 3, // 3 kolom
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          shrinkWrap:
                              true, // Agar GridView tidak mengambil ruang terlalu banyak
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(6, (index) {
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.blueAccent
                                    .withOpacity(0.3), // Warna button
                                borderRadius:
                                    BorderRadius.circular(15), // Rounded edges
                              ),
                              child: Center(
                                // Memastikan button berada di tengah
                                child: Text(
                                  'Button ${index + 1}', // Label button
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bagian bawah dengan list yang bisa discroll
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(
                  top: 8), // Margin atas untuk memberikan jarak
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: 10, // Jumlah list item
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gambar di bagian atas
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(4),
                                topRight: Radius.circular(4)),
                            image: DecorationImage(
                              image: AssetImage(
                                  'lib/images/BnppLogo.png'), // Ganti dengan path gambar Anda
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Container untuk latar belakang putih
                        Container(
                          color: Colors
                              .white, // Mengatur warna latar belakang menjadi putih
                          padding:
                              const EdgeInsets.all(8.0), // Padding untuk isi
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Tanggal
                              Text(
                                '25 September 2024', // Ganti dengan tanggal dinamis jika perlu
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 5),
                              // Title
                              const Text(
                                'Judul Berita',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              // Deskripsi
                              const Text(
                                'Deskripsi singkat dari berita atau konten yang ingin ditampilkan. Ini adalah contoh teks.',
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
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
    );
  }
}
