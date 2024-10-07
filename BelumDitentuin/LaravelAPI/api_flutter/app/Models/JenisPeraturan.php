<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class JenisPeraturan extends Model
{
    use HasFactory;

    protected $table = 'jenis_peraturans';
    protected $primaryKey = 'jenis_peraturan_id';

    // Atribut yang dapat diisi massal
    protected $fillable = ['nama_jenis', 'singkatan_jenis'];

    // Relasi dengan Peraturan
    public function peraturans()
    {
        return $this->hasMany(Peraturan::class, 'jenis_peraturan_id', 'jenis_peraturan_id');
    }
}
