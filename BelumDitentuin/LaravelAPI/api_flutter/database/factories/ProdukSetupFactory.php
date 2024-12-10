<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class ProdukSetupFactory extends Factory
{
    public function definition(): array
    {
        // Path ke file PDF
        $filePath = public_path('files/Modelization_of_cognition_activity_and_motivation_.pdf');

        // Cek jika file ada dan konversi ke base64
        $base64Pdf = '';
        if (file_exists($filePath)) {
            $fileContent = file_get_contents($filePath);
            $base64Pdf = base64_encode($fileContent);
        }

        return [
            'user_id'=> $this->faker->numberBetween(1, 10),
            'jenis_produk_setup_id'=> $this->faker->numberBetween(1, 2),
            'judul_setup'=> $this->faker->sentence(5),
            'deskripsi_setup'=> $this->faker->sentence(20),
            'tag' => $this->faker->randomElement(['Data Evaluasi', 'Kerja Sama', 'Program dan Perencanaan']),
            'file'=> $base64Pdf,
            'status' => $this->faker->numberBetween(1, 3),
            'tgl_pembuatan'=> $this->faker->date(),
            'tgl_upload'=> $this->faker->date(),
        ];
    }
}
