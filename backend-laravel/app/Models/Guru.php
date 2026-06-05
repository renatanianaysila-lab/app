<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model; 

class Guru extends Model
{

       protected $table = 'guru';
       protected $primaryKey = 'guru_id';
       public $incrementing = false; 
       protected $keyType = 'string';

       protected $fillable = [
           'guru_id', 'nama_guru', 'email_guru', 'password_guru', 'foto_profil_guru', 'sertifikasi'
       ];

       protected $hidden = [
           'password_guru',
       ];
}
