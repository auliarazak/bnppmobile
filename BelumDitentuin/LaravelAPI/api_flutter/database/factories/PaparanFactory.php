<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Model>
 */
class PaparanFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $filePath = public_path('files/Modelization_of_cognition_activity_and_motivation_.pdf');

        // Cek jika file ada dan konversi ke base64
        $base64Pdf = '';
        if (file_exists($filePath)) {
            $fileContent = file_get_contents($filePath);
            $base64Pdf = base64_encode($fileContent);
        }

        return [
            'user_id' => $this->faker->numberBetween(1, 10),
            'jenis_paparan_id' =>$this->faker->numberBetween(1,6),
            'judul_paparan' => $this->faker->sentence(5),
            'deskripsi_paparan' => $this->faker->sentence(20),
            'tag' => $this->faker->randomElement(['Data Evaluasi', 'Kerja Sama', 'Program dan Perencanaan', 'All']),
            'pdf_path' => $base64Pdf,
            'tgl_pembuatan' => $this->faker->date(),
            'tgl_upload' => $this->faker->date(),
            'subjek' => $this->faker->word,
            'pembuat' => $this->faker->word,
        ];
    }
}
