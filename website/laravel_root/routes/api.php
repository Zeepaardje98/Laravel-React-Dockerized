<?php

use App\Http\Controllers\TestController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// Test routes - only available in testing environment
if (app()->environment('testing')) {
    Route::post('/test/reset-database', [TestController::class, 'resetDatabase']);
} 