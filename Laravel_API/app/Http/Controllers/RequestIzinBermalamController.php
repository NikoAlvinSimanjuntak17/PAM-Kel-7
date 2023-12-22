<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\RequestIzinBermalam;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use App\Models\User;

class RequestIzinBermalamController extends Controller
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

        $izinBermalamData = RequestIzinBermalam::where('user_id', $user->id)
            ->orderBy('created_at', 'desc')
            ->get();

        return response([
            'RequestIzinBermalam' => $izinBermalamData
        ], 200);
    }
    public function show($id)
    {
        return response([
            'RequestIzinBermalam' => RequestIzinBermalam::where('id', $id)->get()
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

        $user = RequestIzinBermalam::create([
            'reason' => $request->input('reason'),
            'start_date' => $request->input('start_date'),
            'end_date' => $request->input('end_date'),
            'user_id' => auth()->user()->id
        ]);
        return response([
            'message' => 'Request Izin Bermalam dibuat',
            'RequestIzinBermalam'=>$user
        ], 200);
    }

    public function update(Request $request,$id)
    {
        $RequestIzinBermalam= RequestIzinBermalam::find($id);
       if(!$RequestIzinBermalam){
        return response([
            'message' => 'Request Izin Keluar Tidak Ditemukan',
        ], 403);
       }
       if($RequestIzinBermalam->user_id !=auth()->user()->id){
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
       $RequestIzinBermalam->update([
         'reason' => $request->input('reason'),
        'start_date' => $request->input('start_date'),
        'end_date' => $request->input('end_date'),
    ]);
    return response([
        'message' => 'Request Izin Bermalam Telah Diupdate',
        'RequestIzinBermalam'=>$RequestIzinBermalam
    ], 200);
    }

   public function destroy($id){
    $RequestIzinBermalam= RequestIzinBermalam::find($id);
    if(!$RequestIzinBermalam){
     return response([
         'message' => 'Request Izin Bermalam Tidak Ditemukan',
     ], 403);
    }
    if($RequestIzinBermalam->user_id !=auth()->user()->id){
     return response([
         'message' => 'Akun Anda Tidak mengakses Ini',
     ], 403);
    }
    $RequestIzinBermalam->delete();
    return response([
        'message' => 'Request Izin Bermalam Telah Dihapus',
        'RequestIzinBermalam'=>$user
    ], 200);
   }
   public function viewAllRequestsForBaak()
{
    if (auth()->user()->role !== 'baak') {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    $izinBermalamData = RequestIzinBermalam::orderBy('created_at', 'desc')->get();

    return response([
        'RequestIzinBermalam' => $izinBermalamData
    ], 200);
}

public function approveIzinBermalam($id)
{
    if (auth()->user()->role !== 'baak') {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    $izinBermalam = RequestIzinBermalam::find($id);

    if (!$izinBermalam) {
        return response()->json(['message' => 'Request Izin Keluar Tidak Ditemukan'], 404);
    }

    $izinBermalam->status = 'approved';
    $izinBermalam->save();

    return response()->json(['message' => 'Permintaan Izin Keluar Telah Disetujui'], 200);
}
public function rejectIzinBermalam($id)
{
    if (auth()->user()->role !== 'baak') {
        return response()->json(['message' => 'Unauthorized'], 401);
    }

    $izinBermalam = RequestIzinBermalam::find($id);

    if (!$izinBermalam) {
        return response()->json(['message' => 'Request Izin Surat Tidak Ditemukan'], 404);
    }

    $izinBermalam->status = 'rejected';
    $izinBermalam->save();

    return response()->json(['message' => 'Permintaan Izin Surat Telah Ditolak'], 200);
}


}