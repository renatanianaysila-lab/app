<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Payment extends Model
{
    protected $fillable = [
    'murid_id',
    'payment_method',
    'amount',
    'status',
    'qris_code',
    'card_holder',
    ];
}