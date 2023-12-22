<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Baju extends Model
{
    protected $table = 'baju';

    protected $fillable = [
        'ukuran',
        'harga',
    ];

    // Relationship with bookings
    public function bookings()
    {
        return $this->hasMany(BookingBaju::class);
    }
}
