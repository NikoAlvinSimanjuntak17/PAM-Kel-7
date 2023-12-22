<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class RequestIzinSurat extends Model
{
    use HasFactory;
    protected $table ="request_izin_surat";
    protected $fillable = ['user_id','approver_id', 'reason','alamat','status'];


    public function user()
    {
        return $this->belongsTo(User::class);
    }
}