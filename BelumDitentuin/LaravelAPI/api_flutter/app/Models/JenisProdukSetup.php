<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class JenisProdukSetup extends Model
{
    use HasFactory;

    protected $table = 'jenis_produk_setups';
    protected $primaryKey = 'jenis_produk_setup_id';

    // Atribut yang dapat diisi massal
    protected $fillable = ['nama_jenis', 'singkatan_jenis'];

    // Relasi dengan Peraturan
    public function produkSetups()
    {
        return $this->hasMany(Peraturan::class, 'jenis_produk_setup_id', 'jenis_produk_setup_id');
    }
}
