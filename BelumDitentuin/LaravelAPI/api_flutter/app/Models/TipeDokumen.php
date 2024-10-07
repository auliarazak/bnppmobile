<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TipeDokumen extends Model
{
    use HasFactory;

    protected $table = 'tipe_dokumens';
    protected $primaryKey = 'tipe_dok_id';

    // Atribut yang dapat diisi massal
    protected $fillable = ['nama_tipe'];

    // Relasi dengan Peraturan
    public function peraturans()
    {
        return $this->hasMany(Peraturan::class, 'tipe_dok_id', 'tipe_dok_id');
    }
}
