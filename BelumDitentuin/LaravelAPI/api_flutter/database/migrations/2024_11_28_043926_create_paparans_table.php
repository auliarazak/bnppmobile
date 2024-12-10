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
        Schema::create('paparans', function (Blueprint $table) {
            $table->id('paparan_id');
            $table->foreignId('user_id')->references('user_id')->on('users');
            $table->foreignId('jenis_paparan_id')->references('jenis_paparan_id')->on('jenis_paparans');
            $table->string('judul_paparan');
            $table->string('deskripsi_paparan');
            $table->string('tag');
            $table->longText('pdf_path');
            $table->date('tgl_pembuatan')->nullable();
            $table->date('tgl_upload')->nullable();
            $table->string('subjek')->nullable();
            $table->string('pembuat')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('paparans');
    }
};
