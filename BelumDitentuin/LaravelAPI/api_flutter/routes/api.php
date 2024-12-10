<?php

use App\Http\Controllers\BeritaApiController;
use App\Http\Controllers\CrudApiController;
use App\Http\Controllers\LupaPasswordController;
use App\Http\Controllers\LoginController;
use App\Http\Controllers\MoUApiController;
use App\Http\Controllers\PaparanApiController;
use App\Http\Controllers\PeraturanBiroController;
use App\Http\Controllers\PeraturanBNPPApiController;
use App\Http\Controllers\PeraturanDaerahController;
use App\Http\Controllers\PeraturanIntruksiPresidenController;
use App\Http\Controllers\PeraturanKementrianApiController;
use App\Http\Controllers\PeraturanKepalaBNPPController;
use App\Http\Controllers\PeraturanLainnyaController;
use App\Http\Controllers\PeraturanPemerintahApiController;
use App\Http\Controllers\PeraturanPresidenApiController;
use App\Http\Controllers\PeraturanUndangUndangApiController;
use App\Http\Controllers\ProdukSetupBNPPController;
use App\Http\Controllers\RegisterApiController;
use App\Http\Controllers\UserApiController;
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

//Home
Route::get('/user-profile/{userId}', [UserApiController::class, 'getUserProfile']);
// Route::get('/check-role', [UserApiController::class, 'cekRole']);

//profil
Route::get('/user/getEdit/{id}', [UserApiController::class, 'getEdit']);
Route::patch('/user/editUser/{userId}', [UserApiController::class, 'editUserProfil']);
Route::patch('/user/editFoto/{userId}', [UserApiController::class, 'editFotoProfil']);
Route::post('/change-pass', [UserApiController::class, 'changePassword']);

//Peraturan UU
Route::get('/peraturan-uu', [PeraturanUndangUndangApiController::class, 'index']);
Route::get('/peraturan-uu/{id}', [PeraturanUndangUndangApiController::class, 'getDetailed']);

//Peraturan Presiden 
Route::get('/peraturan-presiden', [PeraturanPresidenApiController::class, 'index']);
Route::get('/peraturan-presiden/{id}', [PeraturanPresidenApiController::class, 'getDetailed']);

//Instruksi Presiden
Route::get('/instruksi-presiden', [PeraturanIntruksiPresidenController::class, 'index']);
Route::get('/instruksi-presiden/{id}', [PeraturanIntruksiPresidenController::class, 'getDetailed']);

//Peraturan Pemerintahan
Route::get('/peraturan-pemerintah', [PeraturanPemerintahApiController::class, 'index']);
Route::get('/peraturan-pemerintah/{id}', [PeraturanPemerintahApiController::class, 'getDetailed']);

//Peraturan Mentri
Route::get('/peraturan-mentri', [PeraturanKementrianApiController::class, 'index']);
Route::get('/peraturan-mentri/{id}', [PeraturanKementrianApiController::class, 'getDetailed']);

//peraturan BNPP
Route::get('/peraturan-bnpp', [PeraturanBNPPApiController::class, 'index']);
Route::get('/peraturan-bnpp/{id}', [PeraturanBNPPApiController::class, 'getDetailed']);

//peraturan BNPP
Route::get('/peraturan-kbnpp', [PeraturanKepalaBNPPController::class, 'index']);
Route::get('/peraturan-kbnpp/{id}', [PeraturanKepalaBNPPController::class, 'getDetailed']);

//peraturan Daerah
Route::get('/peraturan-daerah', [PeraturanDaerahController::class, 'index']);
Route::get('/peraturan-daerah/{id}', [PeraturanDaerahController::class, 'getDetailed']);

//peraturan Biro
Route::get('/peraturan-biro', [PeraturanBiroController::class, 'index']);
Route::get('/peraturan-biro/{id}', [PeraturanBiroController::class, 'getDetailed']);

//MoU
Route::get('/peraturan-mou', [MoUApiController::class, 'index']);
Route::get('/peraturan-mou/{id}', [MoUApiController::class, 'getDetailed']);

//peraturan Lainnya
Route::get('/peraturan-lain', [PeraturanLainnyaController::class, 'index']);
Route::get('/peraturan-lain/{id}', [PeraturanLainnyaController::class, 'getDetailed']);

//paparan
Route::get('/cek-level/{id}', [PaparanApiController::class, 'cekLevelUser']);
Route::get('/paparan', [PaparanApiController::class, 'index']);
Route::get('/paparan-ppka', [PaparanApiController::class, 'PPKA']);
Route::get('/paparan-pbwnkp', [PaparanApiController::class, 'PBWNKP']);
Route::get('/paparan-di', [PaparanApiController::class, 'DI']);
Route::get('/paparan-fksdln', [PaparanApiController::class, 'FKSDLN']);
Route::get('/paparan-lain', [PaparanApiController::class, 'LAIN']);
Route::get('/paparan-ssp', [PaparanApiController::class, 'SSP']);
Route::get('/detail-paparan/{id}', [PaparanApiController::class, 'getDetailed']);
Route::get('/getEditPaparan/{id}', [PaparanApiController::class, 'getEdit']);
Route::post('/create-paparan', [PaparanApiController::class, 'create']);
Route::put('/editPaparan/{id}', [PaparanApiController::class, 'update']);
Route::delete('/delete-paparan/{id}', [PaparanApiController::class, 'delete']);

//Produk Setup
Route::get('/produk-setup', [ProdukSetupBNPPController::class, 'getList']);
Route::get('/potret-pbwnkp', [ProdukSetupBNPPController::class, 'PPBWNKP']);
Route::get('/panduan', [ProdukSetupBNPPController::class, 'Panduan']);
Route::get('/detail-produk-setup/{id}', [ProdukSetupBNPPController::class, 'getDetailed']);
Route::post('/create-produk-setup', [ProdukSetupBNPPController::class, 'create']);
Route::put('/editproduk-setup/{id}', [ProdukSetupBNPPController::class, 'update']);
Route::delete('/delete-produk-setup/{id}', [ProdukSetupBNPPController::class, 'delete']);

//berita
Route::get('all-beritas', [BeritaApiController::class, 'getAllBeritas']);
Route::get('/beritas', [BeritaApiController::class, 'index']);
Route::get('/terbaru', [BeritaApiController::class, 'terbaru']);
Route::get('/terlama', [BeritaApiController::class, 'terlama']);
Route::get('/AtoZ', [BeritaApiController::class, 'AtoZ']);
Route::get('/ZtoA', [BeritaApiController::class, 'ZtoA']);
Route::post('/toggleStatus/{id}', [BeritaApiController::class, 'toggleStatus']);
Route::get('/detailBeritas/{id}', [BeritaApiController::class, 'detailBerita']);
Route::get('/berita-dashboard', [BeritaApiController::class, 'beritaDashboard']);
Route::post('/create-berita', [BeritaApiController::class, 'store']);
Route::get('/getEdit/{id}', [BeritaApiController::class, 'getEdit']);
Route::put('/update-berita/{id}', [BeritaApiController::class, 'update']);
Route::delete('/delete-berita/{id}', [BeritaApiController::class, 'destroy']);

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

//LupaPassword
Route::post('/forgot-password', [LupaPasswordController::class, 'sendResetCode']);
Route::post('/verify-reset-code', [LupaPasswordController::class, 'verifyResetCode']);
Route::post('/reset-password', [LupaPasswordController::class, 'resetPassword']);


Route::post('/reverify', [RegisterApiController::class, 'reVerifyEmail']);
Route::post('/verifikasi', [RegisterApiController::class, 'verifikasi']);


