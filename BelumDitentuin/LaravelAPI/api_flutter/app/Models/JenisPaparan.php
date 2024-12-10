<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class JenisPaparan extends Model
{
    use HasFactory;

    protected $table = 'jenis_paparans';
    protected $primaryKey = 'jenis_paparan_id';

    // Atribut yang dapat diisi massal
    protected $fillable = ['nama_jenis', 'singkatan_jenis'];

    // Relasi dengan Peraturan
    public function paparans()
    {
        return $this->hasMany(Peraturan::class, 'jenis_paparan_id', 'jenis_paparan_id');
    }
}
