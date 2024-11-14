<?php

namespace Database\Factories;

use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

class DataUserFactory extends Factory
{
    public function definition(): array
    {
        $filePath = public_path('images/profil.jpeg');

        $base64Pdf = '';
        if (file_exists($filePath)) {
            $fileContent = file_get_contents($filePath);
            $base64Pdf = base64_encode($fileContent);
        }

        return [
            'nip' => $this->faker->unique()->numberBetween(1000000000000000000, 99999999999999999999),  // NIP 19-22 karakter
            'user_id' => User::factory(), 
            'nama' => $this->faker->name(),
            'foto_profil' => $base64Pdf,
            'jenis_kelamin' => $this->faker->randomElement(['Laki-laki', 'Perempuan']),
            'tgl_lahir' => $this->faker->date(),
            'no_telp' => $this->faker->phoneNumber(),
            'alamat' => $this->faker->address(),
        ];
    }
}

