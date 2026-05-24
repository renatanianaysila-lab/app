<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Payment extends Model
{
    protected $fillable = [
        'payment_method',
        'amount',
        'status',
        'qris_code',
        'card_holder',
    ];

    public function transaction()
    {
        return $this->hasOne(Transaction::class);
    }
}