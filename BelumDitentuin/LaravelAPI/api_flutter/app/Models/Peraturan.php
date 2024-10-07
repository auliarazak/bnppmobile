<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Peraturan extends Model
{
    use HasFactory;

    // Tentukan nama tabel jika tidak mengikuti konvensi plural
    protected $table = 'peraturans';

    // Jika Anda ingin mengatur primary key
    protected $primaryKey = 'peraturan_id';

    // Jika primary key bukan auto-increment
    // public $incrementing = false;

    // Tentukan atribut yang dapat diisi massal
    protected $fillable = [
        'user_id',
        'tipe_dok_id',
        'jenis_peraturan_id',
        'teu_id',
        'judul_peraturan',
        'nomor_peraturan',
        'tempat_penetapan_peraturan',
        'tgl_penetapan_peraturan',
        'tgl_pengundangan_peraturan',
        'subjek_peraturan',
        'sumber_peraturan',
        'status_peraturan',
        'bahasa_peraturan',
        'lokasi_peraturan',
        'bidang_hukum_peraturan',
        'penanda_tangan_peraturan',
        'lampiran',
        'abstrak',
        'peraturan_terkait',
    ];

    // Tentukan relasi jika ada
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id', 'user_id');
    }

    public function tipeDokumen()
    {
        return $this->belongsTo(TipeDokumen::class, 'tipe_dok_id', 'tipe_dok_id');
    }

    public function jenisPeraturan()
    {
        return $this->belongsTo(JenisPeraturan::class, 'jenis_peraturan_id', 'jenis_peraturan_id');
    }

    public function teu()
    {
        return $this->belongsTo(TEU::class, 'teu_id', 'teu_id');
    }
}
