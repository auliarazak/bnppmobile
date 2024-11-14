<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('data_users', function (Blueprint $table) {
            $table->id('nip');
            $table->foreignId('user_id')->references('user_id')->on('users');
            $table->string('nama');
            $table->longText('foto_profil')->nullable();
            $table->string('jenis_kelamin');
            $table->date('tgl_lahir')->nullable();
            $table->string('no_telp')->nullable();
            $table->text('alamat')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('data_users');
    }
};
