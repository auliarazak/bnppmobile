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
            ['nama_jenis' => 'Peraturan Pemerintah', 'singkatan_jenis' => 'PP'],
            ['nama_jenis' => 'Peraturan BNPP', 'singkatan_jenis' => 'PBNPP'],
            ['nama_jenis' => 'Peraturan Kementrian', 'singkatan_jenis' => 'PERMEN'],
            ['nama_jenis' => 'Naskah Kesepahaman', 'singkatan_jenis' => 'MoU'],
        ]);

        //teu
        DB::table('t_e_us')->insert([
            ['nama_teu' => 'Badan Nasional Pengelola Perbatasan, Indonesia'],
            ['nama_teu' => 'Kementrian Dalam Negeri, Indonesia'],
            ['nama_teu' => 'Kementrian Luar Negeri, Indonesia'],
            ['nama_teu' => 'Sektretarian Negara, Indonesia'],
        ]);

        //tipe dokumen
        DB::table('tipe_dokumens')->insert([
            ['nama_tipe' => 'PDF'],
            ['nama_tipe' => 'DOC'],
            ['nama_tipe' => 'XLS'],
        ]);


        \App\Models\Peraturan::factory(20)->create();


    }
}
