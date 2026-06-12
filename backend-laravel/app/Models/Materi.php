<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Materi extends Model
{
    protected $table = 'materis';
    
    protected $fillable = [
        'judul',
        'kategori', 
        'deskripsi',
        'video_url',
    ];
}