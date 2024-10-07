<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasOne;

class DataUser extends Model
{
    use HasFactory;

    // Nama tabel jika tidak mengikuti konvensi
    protected $table = 'data_users';

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'nip',
        'nama',
        'jenis_kelamin',
        'tgl_lahir',
        'no_telp',
        'alamat',
    ];

    /**
     * Relasi one-to-one dengan model User.
     *
     * @return \Illuminate\Database\Eloquent\Relations\HasOne
     */
    public function user(): HasOne
    {
        return $this->hasOne(User::class, 'nip', 'nip');
    }
}
