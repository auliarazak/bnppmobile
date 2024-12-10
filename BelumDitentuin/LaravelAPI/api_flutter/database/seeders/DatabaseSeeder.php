<?php

namespace Database\Seeders;

// use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        \App\Models\DataUser::factory(10)->create();
        \App\Models\User::factory(10)->create();


        //Jenis Peraturan
        DB::table('jenis_peraturans')->insert([
            ['nama_jenis' => 'Undang Undang', 'singkatan_jenis' => 'UU'],
            ['nama_jenis' => 'Peraturan Presiden', 'singkatan_jenis' => 'PERPRES'],
            ['nama_jenis' => 'Instruksi Presiden', 'singkatan_jenis' => 'INPRES'],
            ['nama_jenis' => 'Peraturan Pemerintah', 'singkatan_jenis' => 'PP'],
            ['nama_jenis' => 'Peraturan Menteri', 'singkatan_jenis' => 'PERMEN'],
            ['nama_jenis' => 'Peraturan BNPP', 'singkatan_jenis' => 'PBNPP'],
            ['nama_jenis' => 'Peraturan Kepala BNPP', 'singkatan_jenis' => 'PKBNPP'],
            ['nama_jenis' => 'Peraturan Daerah', 'singkatan_jenis' => 'PERDA'],
            ['nama_jenis' => 'Peraturan Biro', 'singkatan_jenis' => 'PB'],
            ['nama_jenis' => 'Naskah Kesepahaman', 'singkatan_jenis' => 'MoU'],
            ['nama_jenis' => 'Peraturan Lainnya', 'singkatan_jenis' => 'LAIN'],
        ]);

        //Jenis T.E.U
        DB::table('t_e_us')->insert([
            ['nama_teu' => 'Badan Nasional Pengelola Perbatasan (BNPP)'],
            ['nama_teu' => 'Sekretariat BNPP'],
            ['nama_teu' => 'Kementerian Dalam Negeri'],
            ['nama_teu' => 'Kementerian Luar Negeri'],
            ['nama_teu' => 'Kementerian Pertahanan'],
            ['nama_teu' => 'Kementerian Keuangan'],
            ['nama_teu' => 'Kementerian Hukum dan Hak Asasi Manusia'],
            ['nama_teu' => 'Kementerian Agraria dan Tata Ruang/Badan Pertanahan Nasional'],
            ['nama_teu' => 'Kementerian Pekerjaan Umum dan Perumahan Rakyat'],
            ['nama_teu' => 'Kementerian Lingkungan Hidup dan Kehutanan'],
            ['nama_teu' => 'Kementerian Kelautan dan Perikanan'],
            ['nama_teu' => 'Kementerian Energi dan Sumber Daya Mineral'],
            ['nama_teu' => 'Kementerian Perhubungan'],
            ['nama_teu' => 'Kementerian Sosial'],
            ['nama_teu' => 'Kementerian Pariwisata dan Ekonomi Kreatif'],
            ['nama_teu' => 'Kementerian Pendidikan, Kebudayaan, Riset, dan Teknologi'],
            ['nama_teu' => 'Badan Informasi Geospasial (BIG)'],
            ['nama_teu' => 'Badan Keamanan Laut (BAKAMLA)'],
            ['nama_teu' => 'Badan Intelijen Negara (BIN)'],
            ['nama_teu' => 'Badan Meteorologi, Klimatologi, dan Geofisika (BMKG)'],
            ['nama_teu' => 'Tentara Nasional Indonesia (TNI)'],
            ['nama_teu' => 'Kepolisian Negara Republik Indonesia (POLRI)'],
            ['nama_teu' => 'Direktorat Kerja Sama Perbatasan Internasional'],
            ['nama_teu' => 'Tim Koordinasi Perbatasan Bilateral'],
            ['nama_teu' => 'Lembaga Administrasi Negara (LAN)'],
            ['nama_teu' => 'Badan Narkotika Nasional (BNN)'],
            ['nama_teu' => 'Lembaga Kebijakan Pengadaan Barang/Jasa Pemerintah (LKPP)'],
        ]);

        //Jenis Paparan
        DB::table('jenis_paparans')->insert([
            ['nama_jenis' => 'Perencanaan Program Kegiatan dan Anggaran', 'singkatan_jenis' => 'PPKA'],
            ['nama_jenis' => 'Pengelolaan Batas Wilayah Negara dan Kawasan Perbatasan', 'singkatan_jenis' => 'PBWNKP'],
            ['nama_jenis' => 'Data dan Informasi', 'singkatan_jenis' => 'DI'],
            ['nama_jenis' => 'Fasilitas Kerja Sama Dalam dan Luar Negeri', 'singkatan_jenis' => 'FKSDLN'],
            ['nama_jenis' => 'Paparan Lainnya', 'singkatan_jenis' => 'LAIN'],
            ['nama_jenis' => 'Surat Surat Penting', 'singkatan_jenis' => 'SSP'],
        ]);
        
        //Jenis Produk Setup
        DB::table('jenis_produk_setups')->insert([
            ['nama_jenis' => 'Potret Pengelolaan Batas Wilayah Negara dan Kawasan Perbatasan', 'singkatan_jenis' => 'PPBWNKP'],
            ['nama_jenis' => 'Panduan', 'singkatan_jenis' => 'PANDUAN'],
        ]);

        \App\Models\ProdukSetup::factory(20)->create();
        \App\Models\Paparan::factory(20)->create();
        \App\Models\Peraturan::factory(30)->create();
        \App\Models\Berita::factory(10)->create();
    }
}
