<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

class DataUserFactory extends Factory
{
    public function definition(): array
    {
        return [
            'nip' => $this->faker->unique()->numberBetween(1000000000000000000, 99999999999999999999),  // NIP 19-22 karakter
            'nama' => $this->faker->name(),
            'jenis_kelamin' => $this->faker->randomElement(['Laki-laki', 'Perempuan']),
            'tgl_lahir' => $this->faker->date(),
            'no_telp' => $this->faker->phoneNumber(),
            'alamat' => $this->faker->address(),
        ];
    }
}

