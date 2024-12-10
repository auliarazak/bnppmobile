<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Berita>
 */
class BeritaFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $filePath = public_path('images/exampleBerita.jpg');

        $base64Pdf = '';
        if (file_exists($filePath)) {
            $fileContent = file_get_contents($filePath);
            $base64Pdf = base64_encode($fileContent);
        }

        return [
            'user_id' => $this->faker->numberBetween(1, 10),
            'judul_berita' => $this->faker->sentence(5),
            'deskripsi_berita' =>  $this->faker->paragraph(5),
            'tgl_berita' => $this->faker->date(),
            'foto_berita' => $base64Pdf,
            'status'=>$this->faker->numberBetween(0,1),
        ];
    }
}
