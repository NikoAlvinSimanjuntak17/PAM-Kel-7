<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RequestIzinKeluar extends Model
{
    use HasFactory;
    protected $table ="request_izin_keluar";
    protected $fillable = ['user_id','approver_id', 'reason', 'start_date', 'end_date', 'status'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

}
