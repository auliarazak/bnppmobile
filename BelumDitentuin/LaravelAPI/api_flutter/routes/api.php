<?php

use App\Http\Controllers\BeritaApiController;
use App\Http\Controllers\LoginController;
use App\Http\Controllers\MoUApiController;
use App\Http\Controllers\PeraturanBNPPApiController;
use App\Http\Controllers\PeraturanKementrianApiController;
use App\Http\Controllers\PeraturanPemerintahApiController;
use App\Http\Controllers\PeraturanPresidenApiController;
use App\Http\Controllers\PeraturanUndangUndangApiController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});
Route::post('/login', [LoginController::class, 'login']);

//Peraturan Presiden 
Route::get('/peraturan-presiden', [PeraturanPresidenApiController::class, 'index']);
Route::get('/peraturan-mentri', [PeraturanKementrianApiController::class, 'index']);
Route::get('/peraturan-uu', [PeraturanUndangUndangApiController::class, 'index']);
Route::get('/peraturan-pemerintah', [PeraturanPemerintahApiController::class, 'index']);
Route::get('/peraturan-mou', [MoUApiController::class, 'index']);
Route::get('/peraturan-bnpp', [PeraturanBNPPApiController::class, 'index']);

//berita
Route::get('/beritas', [BeritaApiController::class, 'index']);

