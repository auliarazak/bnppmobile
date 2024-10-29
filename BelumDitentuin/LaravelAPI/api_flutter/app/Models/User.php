<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'nip',                 // Tambahkan nip agar dapat diisi
        'email',          // Ubah menjadi email_user
        'password',       // Ubah menjadi password_user
        'level_user',          // Ubah menjadi level_user
        'waktu_email_verifikasi' // Ubah menjadi waktu_email_verifikasi
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password_user',       // Ubah menjadi password_user
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'waktu_email_verifikasi' => 'datetime',  // Ubah menjadi waktu_email_verifikasi
        'password_user' => 'hashed',              // Ubah menjadi password_user
    ];

    /**
     * Relasi one-to-one dengan model DataUser.
     *
     * @return \Illuminate\Database\Eloquent\Relations\BelongsTo
     */
    public function dataUser()
    {
        return $this->belongsTo(DataUser::class, 'nip', 'nip');
    }
    
}
