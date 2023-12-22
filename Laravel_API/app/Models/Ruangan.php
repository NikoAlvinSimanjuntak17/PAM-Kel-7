<?php

// app/Models/Ruangan.php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Ruangan extends Model
{
    use HasFactory;

    protected $table = 'ruangan';

    protected $fillable = [
        'NamaRuangan',
    ];

    public function bookings()
    {
        return $this->hasMany(BookingRuangan::class, 'room_id');
    }
}
