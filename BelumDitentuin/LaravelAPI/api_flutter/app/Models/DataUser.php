<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasOne;

class DataUser extends Model
{
    use HasFactory;

    // Nama tabel jika tidak mengikuti konvensi
    protected $table = 'data_users';

    protected $primaryKey = 'nip';

    protected $fillable = [
        'nip',
        'user_id',
        'nama',
        'foto_profil',
        'jenis_kelamin',
        'tgl_lahir',
        'no_telp',
        'alamat'
    ];

    /**
     * Relasi one-to-one dengan model User.
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasOne
     */
    public function user(): belongsTo
    {
        return $this->belongsTo(User::class, 'user_id', 'user_id');
    }
}
