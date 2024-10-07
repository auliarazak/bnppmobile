<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class TEU extends Model
{
    use HasFactory;

    protected $table = 't_e_us';
    protected $primaryKey = 'teu_id';

    // Atribut yang dapat diisi massal
    protected $fillable = ['nama_teu'];

    // Relasi dengan Peraturan
    public function peraturans()
    {
        return $this->hasMany(Peraturan::class, 'teu_id', 'teu_id');
    }
}
