<?php

namespace App\Http\Controllers;

use App\Models\Peraturan;
use Illuminate\Http\Request;

class PeraturanUndangUndangApiController extends Controller
{
    public function index()
    {
        // Mengambil semua peraturan dengan jenis_peraturan_id = 2
        $peraturans = Peraturan::where('jenis_peraturan_id', 1)->get();

        // Mengembalikan response JSON
        return response()->json($peraturans);
    }
}
