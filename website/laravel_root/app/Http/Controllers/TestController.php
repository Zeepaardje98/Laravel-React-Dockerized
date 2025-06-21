<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\DB;

class TestController extends Controller
{
    /**
     * Reset the database for integration tests
     * This endpoint should only be available in testing environment
     */
    public function resetDatabase(Request $request)
    {
        // Only allow this in testing environment
        if (app()->environment() !== 'testing') {
            abort(404);
        }

        try {
            // Run fresh migrations with seeding
            Artisan::call('migrate:fresh', ['--seed' => true]);
            
            return response()->json(['message' => 'Database reset successfully']);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }
} 