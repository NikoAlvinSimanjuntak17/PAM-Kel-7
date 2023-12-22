<?php

// app/Models/BookingRuangan.php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class BookingRuangan extends Model
{
    use HasFactory;

    protected $table = 'booking_ruangan';

    protected $fillable = [
        'reason',
        'user_id',
        'room_id',
        'start_time',
        'end_time',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function approver()
    {
        return $this->belongsTo(User::class, 'approver_id');
    }

    public function room()
    {
        return $this->belongsTo(Ruangan::class);
    }
}
