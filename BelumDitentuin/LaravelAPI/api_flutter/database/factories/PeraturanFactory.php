<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Barryvdh\DomPDF\Facade\Pdf;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Peraturan>
 */
class PeraturanFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
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
            'user_id' => $this->faker->numberBetween(1, 10),
            'jenis_peraturan_id' => $this->faker->numberBetween(1, 6),
            'teu_id' => $this->faker->numberBetween(1, 4),
            'judul_peraturan' => $this->faker->sentence(5),
            'nomor_peraturan' => $this->faker->unique()->numberBetween(1, 100),
            'tahun_peraturan' => $this->faker->numberBetween(1945, 2025),
            'pdf_path' => $base64Pdf,
            'tempat_penetapan_peraturan' => $this->faker->city,
            'tgl_penetapan_peraturan' => $this->faker->date(),
            'tgl_pengundangan_peraturan' => $this->faker->date(),
            'subjek_peraturan' => $this->faker->word,
            'sumber_peraturan' => $this->faker->word,
            'status_peraturan' => $this->faker->word,
            'bahasa_peraturan' => $this->faker->languageCode,
            'lokasi_peraturan' => $this->faker->address,
            'bidang_hukum_peraturan' => $this->faker->word,
            'penanda_tangan_peraturan' => $this->faker->name,
            'lampiran' => $this->faker->text(200),
            'abstrak' => $this->faker->text(300),
            'peraturan_terkait' => $this->faker->word,
        ];
    }
}
