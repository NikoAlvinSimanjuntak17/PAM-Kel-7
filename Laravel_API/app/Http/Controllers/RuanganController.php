<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Ruangan;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use App\Models\User;

class RuanganController extends Controller
{
    public function index()
    {
        $rooms = Ruangan::all();

        return response()->json(['Ruangan' => $rooms], 200);
    }
}