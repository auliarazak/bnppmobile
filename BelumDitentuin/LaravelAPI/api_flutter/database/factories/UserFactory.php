<?php

namespace Database\Factories;

use App\Models\DataUser;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class UserFactory extends Factory
{
    public function definition(): array
    {
        return [ // Mengambil NIP dari data_users
            'email' => $this->faker->unique()->safeEmail(),
            'password' => Hash::make('password'),  // Password default atau bisa menggunakan hash bcrypt
            'level_user' => $this->faker->numberBetween(1, 5),  // Misalkan level_user antara 1 dan 5
            'kode_verifikasi' => $this->faker->numberBetween(100000, 999999),  // Misalkan level_user antara 1 dan 5
            'waktu_email_verifikasi' => now(),
            'remember_token' => $this->faker->numberBetween(100000, 999999),
        ];
    }

    public function unverified(): static
    {
        return $this->state(fn(array $attributes) => [
            'email_verified_at' => null,
        ]);
    }
}
