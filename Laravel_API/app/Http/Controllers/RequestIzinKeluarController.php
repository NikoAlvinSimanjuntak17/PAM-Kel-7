<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\RequestIzinKeluar;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use App\Models\User;

class RequestIzinKeluarController extends Controller
{
   /**
     * Create a new leave request.
     *
     * @param  Request  $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function index()
    {
        $user = Auth::user();

        $izinKeluarData = RequestIzinKeluar::where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->get();

        return response([
            'RequestIzinKeluar' => $izinKeluarData
        ], 200);
    }
    public function show($id)
    {
        return response([
            'RequestIzinKeluar' => RequestIzinKeluar::where('id', $id)->get()
        ], 200);
    }


    public function store(Request $request)
    {

        $rules = [
            'reason' => 'required|string',
            'start_date' => 'required',
            'end_date' =>'required',
        ];
        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }

        $user = RequestIzinKeluar::create([
            'reason' => $request->input('reason'),
            'start_date' => $request->input('start_date'),
            'end_date' => $request->input('end_date'),
            'user_id' => auth()->user()->id
        ]);
        return response([
            'message' => 'Request Izin Keluar dibuat',
            'RequestIzinKeluar'=>$user
        ], 200);
    }

    public function update(Request $request,$id)
    {
        $RequestIzinKeluar= RequestIzinKeluar::find($id);
       if(!$RequestIzinKeluar){
        return response([
            'message' => 'Request Izin Keluar Tidak Ditemukan',
        ], 403);
       }
       if($RequestIzinKeluar->user_id !=auth()->user()->id){
        return response([
            'message' => 'Akun Anda Tidak mengakses Ini',
        ], 403);
       }
       $validator = Validator::make($request->all(), [
        'reason' => 'required|string',
        'start_date' => 'required|date',
        'end_date' => 'required|date',
    ]);

    if ($validator->fails()) {
        return response()->json($validator->errors(), 400);
    }
       $RequestIzinKeluar->update([
         'reason' => $request->input('reason'),
        'start_date' => $request->input('start_date'),
        'end_date' => $request->input('end_date'),
    ]);
    return response([
        'message' => 'Request Izin Keluar Telah Diupdate',
        'RequestIzinKeluar'=>$RequestIzinKeluar
    ], 200);
    }

   public function destroy($id){
    $RequestIzinKeluar= RequestIzinKeluar::find($id);
    if(!$RequestIzinKeluar){
     return response([
         'message' => 'Request Izin Keluar Tidak Ditemukan',
     ], 403);
    }
    if($RequestIzinKeluar->user_id !=auth()->user()->id){
     return response([
         'message' => 'Akun Anda Tidak mengakses Ini',
     ], 403);
    }
    $RequestIzinKeluar->delete();
    return response([
        'message' => 'Request Izin Keluar Telah Dihapus',
        'RequestIzinKeluar'=>$user
    ], 200);
   }
   public function viewAllRequestsForBaak()
{
    if (auth()->user()->role !== 'baak') {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    $izinKeluarData = RequestIzinKeluar::orderBy('created_at', 'desc')->get();

    return response([
        'RequestIzinKeluar' => $izinKeluarData
    ], 200);
}

public function approveIzinKeluar($id)
{
    if (auth()->user()->role !== 'baak') {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    $izinKeluar = RequestIzinKeluar::find($id);

    if (!$izinKeluar) {
        return response()->json(['message' => 'Request Izin Keluar Tidak Ditemukan'], 404);
    }

    $izinKeluar->status = 'approved';
    $izinKeluar->save();

    return response()->json(['message' => 'Permintaan Izin Keluar Telah Disetujui'], 200);
}
public function rejectIzinKeluar($id)
{
    if (auth()->user()->role !== 'baak') {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    $izinKeluar = RequestIzinKeluar::find($id);

    if (!$izinKeluar) {
        return response()->json(['message' => 'Request Izin Keluar Tidak Ditemukan'], 404);
    }

    $izinKeluar->status = 'rejected';
    $izinKeluar->save();

    return response()->json(['message' => 'Permintaan Izin Keluar Telah Ditolak'], 200);
}



}