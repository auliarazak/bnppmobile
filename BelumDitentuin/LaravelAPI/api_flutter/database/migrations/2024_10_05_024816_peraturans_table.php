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
        Schema::create('peraturans', function (Blueprint $table) {
            $table->id('peraturan_id');
            $table->foreignId('user_id')->references('user_id')->on('users');
            $table->foreignId('tipe_dok_id')->references('tipe_dok_id')->on('tipe_dokumens');
            $table->foreignId('jenis_peraturan_id')->references('jenis_peraturan_id')->on('jenis_peraturans');
            $table->foreignId('teu_id')->references('teu_id')->on('t_e_us');
            $table->string('judul_peraturan');
            $table->string('nomor_peraturan');
            $table->string('tempat_penetapan_peraturan');
            $table->date('tgl_penetapan_peraturan');
            $table->date('tgl_pengundangan_peraturan');
            $table->string('subjek_peraturan');
            $table->string('sumber_peraturan');
            $table->string('status_peraturan');
            $table->string('bahasa_peraturan');
            $table->string('lokasi_peraturan');
            $table->string('bidang_hukum_peraturan');
            $table->string('penanda_tangan_peraturan');
            $table->text('lampiran');
            $table->text('abstrak');
            $table->string('peraturan_terkait')->nullable();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('peraturans');

    }
};
