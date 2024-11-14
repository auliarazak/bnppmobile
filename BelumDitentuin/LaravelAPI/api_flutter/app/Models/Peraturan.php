<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Peraturan extends Model
{
    use HasFactory;

    protected $table = 'peraturans';
    protected $primaryKey = 'peraturan_id';
    public $timestamps = true;

    protected $fillable = [
        'user_id',
        'jenis_peraturan_id',
        'teu_id',
        'judul_peraturan',
        'nomor_peraturan',
        'tahun_peraturan',
        'pdf_path',
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

    protected $casts = [
        'tgl_penetapan_peraturan' => 'date',
        'tgl_pengundangan_peraturan' => 'date',
        'created_at' => 'datetime',
        'updated_at' => 'datetime',
    ];

    // Tentukan relasi jika ada
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id', 'user_id');
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
