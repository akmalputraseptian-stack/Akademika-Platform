<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Notifications\Notifiable;

class Mahasiswa extends Model
{
    use HasApiTokens, Notifiable;

    protected $fillable = [
        'nim',
        'nama',
        'jurusan',
        'angkatan',
        'email',
        'status',
        'gpa',
        'sks',
        'profilePic',
        'class',
        'password',
    ];

    protected $hidden = [
        'password',
    ];

    public function krs()
    {
        return $this->hasMany(Krs::class);
    }
}
