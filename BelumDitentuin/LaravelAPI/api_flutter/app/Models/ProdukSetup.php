<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ProdukSetup extends Model
{
    use HasFactory;

    protected $table = 'produk_setups';
    protected $primaryKey = 'produk_setup_id';
    public $timestamps = true;

    protected $fillable = [
        'user_id',
        'jenis_produk_setup_id',
        'judul_setup',
        'deskripsi_setup',
        'tag',
        'file',
        'status',
        'tgl_pembuatan',
        'tgl_upload',
    ];

    protected $casts = [
        'tgl_pembuatan' => 'date',
        'tgl_upload' => 'date',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    // Tentukan relasi jika ada
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id', 'user_id');
    }

    public function jenisProdukSetup()
    {
        return $this->belongsTo(JenisProdukSetup::class, 'jenis_produk_setup_id', 'jenis_produk_setup_id');
    }
}
