<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class BookingBaju extends Model
{
    protected $table = 'booking_baju';

    protected $fillable = [
        'user_id',
        'baju_id',
        'metode_pembayaran',
        'tanggal_pengambilan',
        'status',
    ];

    // Relationship with user
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    // Relationship with baju
    public function baju()
    {
        return $this->belongsTo(Baju::class);
    }
}
