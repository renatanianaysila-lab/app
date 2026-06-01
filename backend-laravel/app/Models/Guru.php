<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Laravel\Sanctum\HasApiTokens;

class Guru extends Model
{
    use HasApiTokens;

       protected $table = 'guru';
       protected $primaryKey = 'guru_id';
       public $incrementing = false; // Di PDM juga berupa CHAR(5)
       protected $keyType = 'string';

       protected $fillable = [
           'guru_id', 'nama_guru', 'email_guru', 'password_guru', 'foto_profil_guru', 'sertifikasi'
       ];

       protected $hidden = [
           'password_guru',
       ];
}
