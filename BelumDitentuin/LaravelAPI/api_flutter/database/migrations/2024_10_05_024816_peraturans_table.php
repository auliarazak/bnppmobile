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
            $table->foreignId('jenis_peraturan_id')->references('jenis_peraturan_id')->on('jenis_peraturans');
            $table->foreignId('teu_id')->references('teu_id')->on('t_e_us');
            $table->string('judul_peraturan');
            $table->string('nomor_peraturan');
            $table->string('tahun_peraturan');
            $table->longText('pdf_path');
            $table->string('tempat_penetapan_peraturan')->nullable();
            $table->date('tgl_penetapan_peraturan')->nullable();
            $table->date('tgl_pengundangan_peraturan')->nullable();
            $table->string('subjek_peraturan')->nullable();
            $table->string('sumber_peraturan')->nullable();
            $table->string('status_peraturan')->nullable();
            $table->string('bahasa_peraturan')->nullable();
            $table->string('lokasi_peraturan')->nullable();
            $table->string('bidang_hukum_peraturan')->nullable();
            $table->string('penanda_tangan_peraturan')->nullable();
            $table->text('lampiran')->nullable();
            $table->text('abstrak')->nullable();
            $table->string('peraturan_terkait')->nullable();
            $table->timestamps();
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
