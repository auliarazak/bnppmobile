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
        Schema::create('produk_setups', function (Blueprint $table) {
            $table->id('produk_setup_id');
            $table->foreignId('user_id')->references('user_id')->on('users');
            $table->foreignId('jenis_produk_setup_id')->references('jenis_produk_setup_id')->on('jenis_produk_setups');
            $table->string('judul_setup');
            $table->string('deskripsi_setup');
            $table->string('tag'); //datev,, kerma, per
            $table->longText('file');
            $table->tinyInteger('status');
            $table->date('tgl_pembuatan');
            $table->date('tgl_upload');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('produk_setups');
    }
};
