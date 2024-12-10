<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Paparan extends Model
{
    use HasFactory;

    protected $table = 'paparans';
    protected $primaryKey = 'paparan_id';
    public $timestamps = true;

    protected $fillable = [
        'user_id',
        'judul_paparan',
        'deskripsi_paparan',
        'tag',
        'pdf_path',
        'tgl_pembuatan',
        'tgl_upload',
        'subjek',
        'pembuat',
    ];

    protected $casts = [
        "tgl_pembuatan" => "date",
        "tgl_upload" => "date",
        "created_at" => "datetime",
        "updated_at" => "datetime",
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id', 'user_id');
    }

    public function jenisPaparan()
    {
        return $this->belongsTo(JenisPaparan::class, 'jenis_paparan_id', 'jenis_paparan_id');
    }
}
