<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Model>
 */
class JenisPeraturanFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            // 'nama_jenis' => DataUser::factory(),  // Mengambil NIP dari data_users
            // 'singkatan_jenis' => $this->faker->unique()->safeEmail(),
        ];
    }
}
