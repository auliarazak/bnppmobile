<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

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
        return [
            'user_id' => $this->faker->numberBetween(1, 10),       // Random user_id antara 1-10
            'tipe_dok_id' => $this->faker->numberBetween(1, 3),     // Random tipe_dok_id antara 1-3
            'jenis_peraturan_id' => $this->faker->numberBetween(1, 6), // Random jenis_peraturan_id antara 1-6
            'teu_id' => $this->faker->numberBetween(1, 4),          // Random teu_id antara 1-4
            'judul_peraturan' => $this->faker->sentence(5),         // Judul peraturan
            'nomor_peraturan' => $this->faker->unique()->word,      // Nomor peraturan
            'tempat_penetapan_peraturan' => $this->faker->city,     // Tempat penetapan
            'tgl_penetapan_peraturan' => $this->faker->date(),      // Tanggal penetapan
            'tgl_pengundangan_peraturan' => $this->faker->date(),   // Tanggal pengundangan
            'subjek_peraturan' => $this->faker->word,               // Subjek peraturan
            'sumber_peraturan' => $this->faker->word,               // Sumber peraturan
            'status_peraturan' => $this->faker->word,               // Status peraturan
            'bahasa_peraturan' => $this->faker->languageCode,       // Bahasa peraturan
            'lokasi_peraturan' => $this->faker->address,            // Lokasi peraturan
            'bidang_hukum_peraturan' => $this->faker->word,         // Bidang hukum peraturan
            'penanda_tangan_peraturan' => $this->faker->name,       // Penanda tangan peraturan
            'lampiran' => $this->faker->text(200),                  // Lampiran
            'abstrak' => $this->faker->text(300),                   // Abstrak
            'peraturan_terkait' => $this->faker->word,              // Peraturan terkait
        ];
    }
}
