<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\RequestIzinSurat;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use App\Models\User;

class RequestSuratController extends Controller
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

        $izinSuratData = RequestIzinSurat::where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->get();

        return response([
            'RequestIzinSurat' => $izinSuratData
        ], 200);
    }
    public function show($id)
    {
        return response([
            'RequestIzinSurat' => RequestIzinSurat::where('id', $id)->get()
        ], 200);
    }


    public function store(Request $request)
    {

        $rules = [
            'reason' => 'required|string',
            'alamat' => 'required|string',
        ];
        $validator = Validator::make($request->all(), $rules);
        if ($validator->fails()) {
            return response()->json($validator->errors(), 400);
        }

        $user = RequestIzinSurat::create([
            'reason' => $request->input('reason'),
            'alamat' => $request->input('alamat'),
            'user_id' => auth()->user()->id
        ]);
        return response([
            'message' => 'Request Izin Surat dibuat',
            'RequestIzinSurat'=>$user
        ], 200);
    }

    public function update(Request $request,$id)
    {
        $RequestIzinSurat= RequestIzinSurat::find($id);
       if(!$RequestIzinSurat){
        return response([
            'message' => 'Request Izin Surat Tidak Ditemukan',
        ], 403);
       }
       if($RequestIzinSurat->user_id !=auth()->user()->id){
        return response([
            'message' => 'Akun Anda Tidak mengakses Ini',
        ], 403);
       }
       $validator = Validator::make($request->all(), [
        'reason' => 'required|string',
        'alamat' => 'required|string'
    ]);

    if ($validator->fails()) {
        return response()->json($validator->errors(), 400);
    }
       $RequestIzinSurat->update([
         'reason' => $request->input('reason'),
         'alamat' => $request->input('alamat'),
    ]);
    return response([
        'message' => 'Request Izin Surat Telah Diupdate',
        'RequestSurat'=>$RequestIzinSurat
    ], 200);
    }

   public function destroy($id){
    $RequestIzinSurat= RequestIzinSurat::find($id);
    if(!$RequestIzinSurat){
     return response([
         'message' => 'Request Izin Surat Tidak Ditemukan',
     ], 403);
    }
    if($RequestIzinSurat->user_id !=auth()->user()->id){
     return response([
         'message' => 'Akun Anda Tidak mengakses Ini',
     ], 403);
    }
    $RequestIzinSurat->delete();
    return response([
        'message' => 'Request Izin Keluar Telah Dihapus',
        'RequestSurat'=>$user
    ], 200);
   }
   public function viewAllRequestsForBaak()
{
    if (auth()->user()->role !== 'baak') {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    $izinSuratData = RequestIzinSurat::orderBy('created_at', 'desc')->get();

    return response([
        'RequestIzinSurat' => $izinSuratData
    ], 200);
}

public function approveIzinSurat($id)
{
    if (auth()->user()->role !== 'baak') {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    $izinSurat = RequestIzinSurat::find($id);

    if (!$izinSurat) {
        return response()->json(['message' => 'Request Izin Surat Tidak Ditemukan'], 404);
    }

    $izinSurat->status = 'approved';
    $izinSurat->save();

    return response()->json(['message' => 'Permintaan Izin Surat Telah Disetujui'], 200);
}
public function rejectIzinSurat($id)
{
    if (auth()->user()->role !== 'baak') {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    $izinSurat = RequestIzinSurat::find($id);

    if (!$izinSurat) {
        return response()->json(['message' => 'Request Izin Surat Tidak Ditemukan'], 404);
    }

    $izinSurat->status = 'rejected';
    $izinSurat->save();

    return response()->json(['message' => 'Permintaan Izin Surat Telah Ditolak'], 200);
}
}