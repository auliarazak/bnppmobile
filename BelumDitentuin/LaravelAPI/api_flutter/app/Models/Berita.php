<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Berita extends Model
{
    use HasFactory;

    protected $table = "beritas";

    protected $primaryKey = 'berita_id';

    protected $fillable = [
        'user_id',
        'judul_berita',
        'deskripsi_berita',
        'tgl_berita',
        'foto_berita',
        'status'
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class, 'user_id', 'user_id');
    }
}
