<?php

use App\Http\Controllers\BeritaApiController;
use App\Http\Controllers\CrudApiController;
use App\Http\Controllers\LoginController;
use App\Http\Controllers\MoUApiController;
use App\Http\Controllers\PeraturanBNPPApiController;
use App\Http\Controllers\PeraturanKementrianApiController;
use App\Http\Controllers\PeraturanPemerintahApiController;
use App\Http\Controllers\PeraturanPresidenApiController;
use App\Http\Controllers\PeraturanUndangUndangApiController;
use App\Http\Controllers\RegisterApiController;
use App\Mail\Siranta;
use App\Models\Peraturan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
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
Route::get('/peraturan-presiden/{id}', [PeraturanPresidenApiController::class, 'getDetailed']);

//Peraturan Mentri
Route::get('/peraturan-mentri', [PeraturanKementrianApiController::class, 'index']);
Route::get('/peraturan-mentri/{id}', [PeraturanKementrianApiController::class, 'getDetailed']);

//Peraturan UU
Route::get('/peraturan-uu', [PeraturanUndangUndangApiController::class, 'index']);
Route::get('/peraturan-uu/{id}', [PeraturanUndangUndangApiController::class, 'getDetailed']);

//Peraturan Pemerintahan
Route::get('/peraturan-pemerintah', [PeraturanPemerintahApiController::class, 'index']);
Route::get('/peraturan-pemerintah/{id}', [PeraturanPemerintahApiController::class, 'getDetailed']);

//MoU
Route::get('/peraturan-mou', [MoUApiController::class, 'index']);
Route::get('/peraturan-mou/{id}', [MoUApiController::class, 'getDetailed']);

//peraturanBNPP
Route::get('/peraturan-bnpp', [PeraturanBNPPApiController::class, 'index']);
Route::get('/peraturan-bnpp/{id}', [PeraturanBNPPApiController::class, 'getDetailed']);

//berita
Route::get('/beritas', [BeritaApiController::class, 'index']);

//CRUD Peraturan
    //create
Route::get('/create-peraturan', [CrudApiController::class, 'index']);
Route::post('/peraturan', [CrudApiController::class, 'create']);
    //read
Route::get('/all-peraturan', [CrudApiController::class, 'AllPeraturan']);
Route::get('/edit-detail/{id}', [CrudApiController::class, 'getEdit']);
    //update
Route::put('/editPeraturan/{id}', [CrudApiController::class, 'update']);
Route::patch('/editPeraturan/{id}', [CrudApiController::class, 'update']);
    //delete
Route::delete('/deletePeraturan/{id}', [CrudApiController::class, 'delete']);


//Registration
Route::post('/register', [RegisterApiController::class, 'checkAndRegister']);
Route::post('/verify-email', [RegisterApiController::class, 'verifyEmail']);
Route::post('/register/resend', [RegisterApiController::class, 'resendVerificationCode']);

//contoh
// Route::get('tesEmail', function(){
//     Mail::to('yefriafrizandra@gmail.com')->send(new Siranta());
// });

