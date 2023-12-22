<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use App\Models\BookingBaju;
use App\Models\User;
use App\Models\Baju;

class BookingBajuController extends Controller
{
    public function index()
    {
        $user = Auth::user();

        $bookingBaju = BookingBaju::with('baju')
            ->where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->get();

        return response([
            'BookingBaju' => $bookingBaju,
        ], 200);
    }

    public function create($id)
    {
        $baju = Baju::find($id);

        if (!$baju) {
            return response([
                'message' => 'Ukuran baju tidak ditemukan',
            ], 404);
        }

        return response([
            'UkuranBaju' => $baju,
        ], 200);
    }

    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'baju_id' => 'required|exists:baju,id',
            'metode_pembayaran' => 'required|in:transfer', // Hanya menerima 'transfer'
            'tanggal_pengambilan' => 'required|date',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }

        $user = Auth::user();
        $baju = Baju::find($request->input('baju_id'));

        if (!$baju) {
            return response()->json(['message' => 'Baju not found'], 404);
        }

        $bookingBaju = BookingBaju::create([
            'user_id' => $user->id,
            'baju_id' => $baju->id,
            'metode_pembayaran' => $request->input('metode_pembayaran'),
            'tanggal_pengambilan' => $request->input('tanggal_pengambilan'),
            'status' => 'pending',
            // Jika ada kolom lain yang perlu diisi, tambahkan di sini
        ]);

        return response()->json([
            'message' => 'Pemesanan Baju dibuat',
            'booking_baju' => $bookingBaju,
        ], 200);
    }


    public function show(string $id)
    {
        $bookingBaju = BookingBaju::with('baju')
            ->find($id);

        if (!$bookingBaju) {
            return response([
                'message' => 'Booking Baju tidak ditemukan',
            ], 404);
        }

        return response([
            'BookingBaju' => $bookingBaju,
        ], 200);
    }

    public function update(Request $request, string $id)
    {
        $bookingBaju = BookingBaju::find($id);

        if (!$bookingBaju) {
            return response([
                'message' => 'Booking Baju tidak ditemukan',
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'ukuran_baju' => 'required|exists:baju,id',
            'metode_pembayaran' => 'required|in:langsung,transfer',
            'tanggal_pengambilan' => 'required|date',
            // Tambahan validasi lain jika diperlukan
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }

        $baju = Baju::find($request->input('ukuran_baju'));

        $bookingBaju->update([
            'baju_id' => $baju->id,
            'tanggal_pengambilan' => $request->input('tanggal_pengambilan'),
            'status' => 'pending', // Status pembayaran bisa diubah di sini
            // Update kolom lain jika diperlukan
        ]);

        return response([
            'message' => 'Booking Baju telah diupdate',
            'BookingBaju' => $bookingBaju,
        ], 200);
    }

    public function destroy(string $id)
    {
        $bookingBaju = BookingBaju::find($id);

        if (!$bookingBaju) {
            return response([
                'message' => 'Booking Baju tidak ditemukan',
            ], 404);
        }

        $bookingBaju->delete();

        return response([
            'message' => 'Booking Baju telah dihapus',
        ], 200);
    }

    public function getBaju()
    {
    $baju = Baju::all();

    return response()->json(['Baju' => $baju]);
    }


public function viewAllRequestsForBaak()
{
    // Pastikan bahwa pengguna yang melakukan permintaan memiliki peran 'baak'
    if (auth()->user()->role !== 'baak') {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    // Mengambil semua data BookingBaju
    $bookingBajuData = BookingBaju::orderBy('created_at', 'desc')->get();

    return response([
        'BookingBaju' => $bookingBajuData
    ], 200);
}

public function approveBookingBaju($id)
{
    // Pastikan bahwa pengguna yang melakukan permintaan memiliki peran 'baak'
    if (auth()->user()->role !== 'baak') {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    // Cari permintaan izin keluar berdasarkan ID
    $bookingBaju = BookingBaju::find($id);

    if (!$bookingBaju) {
        return response()->json(['message' => 'Request Izin Keluar Tidak Ditemukan'], 404);
    }

    // Update status permintaan izin keluar menjadi 'approved'
    $bookingBaju->status = 'approved';
    $bookingBaju->save();

    return response()->json(['message' => 'Permintaan Izin Keluar Telah Disetujui'], 200);
}

public function rejectBookingBaju($id)
{
    // Pastikan bahwa pengguna yang melakukan permintaan memiliki peran 'baak'
    if (auth()->user()->role !== 'baak') {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    // Cari permintaan izin keluar berdasarkan ID
    $bookingBaju = BookingBaju::find($id);

    if (!$bookingBaju) {
        return response()->json(['message' => 'Request Izin Keluar Tidak Ditemukan'], 404);
    }

    // Update status permintaan izin keluar menjadi 'rejected'
    $bookingBaju->status = 'rejected';
    $bookingBaju->save();

    return response()->json(['message' => 'Permintaan Izin Keluar Telah Ditolak'], 200);
}

}
