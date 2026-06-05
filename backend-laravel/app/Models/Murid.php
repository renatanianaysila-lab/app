<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Murid extends Model
{

       protected $table = 'murid';
       protected $primaryKey = 'murid_id';
       public $incrementing = false; 
       protected $keyType = 'string';

       protected $fillable = [
           'murid_id', 'nama_murid', 'email_murid', 'password_murid', 'foto_profil_murid', 'tanggal_lahir', 'tanggal_daftar'
       ];

       protected $hidden = [
           'password_murid',
       ];
}
