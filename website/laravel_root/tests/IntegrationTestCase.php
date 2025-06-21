<?php

namespace Tests;

use GuzzleHttp\Client;
use GuzzleHttp\Cookie\CookieJar;
use App\Models\User;

abstract class IntegrationTestCase extends TestCase
{
    protected $client;

    protected function setUp(): void
    {
        parent::setUp();

        // Clear any existing session/cookies
        $this->cleanSession();
    }

    protected function tearDown(): void
    {
        parent::tearDown();

        // Clean up any test data from previous tests
        $this->cleanupTestData();
    }

    /**
     * Clear session and cookies to ensure test isolation
     */
    protected function cleanSession()
    {
        // Clear cookies from the client
        if ($this->client && $this->client->getConfig('cookies')) {
            $this->client->getConfig('cookies')->clear();
        }

        $cookieJar = new CookieJar();

        // Create a new client with fresh cookies
        $this->client = new Client([
            'base_uri' => env('APP_URL', 'https://localhost'),
            'verify' => false,
            'cookies' => $cookieJar,
        ]);
    }

    /**
     * Clean up test data from the database
     */
    protected function cleanupTestData()
    {
        try {
            // Make a request to the database reset endpoint (API route, no CSRF needed)
            $response = $this->client->post('/api/test/reset-database', [
                'headers' => [
                    'Accept' => 'application/json',
                ],
            ]);
            
            // Verify the reset was successful
            if ($response->getStatusCode() !== 200) {
                throw new \Exception('Failed to reset database: ' . $response->getBody());
            }
        } catch (\Exception $e) {
            // Log the error but don't fail the test
            error_log('Failed to reset database: ' . $e->getMessage());
        }
    }

    protected function getCsrfToken($page = '/login')
    {
        $response = $this->client->get($page);
        preg_match('/<meta name="csrf-token" content="([^"]+)"/', (string) $response->getBody(), $matches);
        return $matches[1] ?? null;
    }

    protected function createTestUser($email, $password)
    {
        return User::factory()->create([
            'email' => $email,
            'password' => bcrypt($password),
        ]);
    }

    protected function login($email, $password)
    {
        $response = $this->requestWithXsrf('POST', '/login', [
            'email' => $email,
            'password' => $password,
        ], '/login');

        $this->assertEquals(302, $response->getStatusCode(), 'Login should redirect');
    }

    /**
     * Get the XSRF-TOKEN cookie value after visiting a page that sets it.
     */
    protected function getXsrfToken($page = '/register')
    {
        $this->client->get($page);
        $cookieJar = $this->client->getConfig('cookies');
        
        $xsrfToken = null;  
        if ($cookieJar) {
            foreach ($cookieJar->toArray() as $cookie) {
                if ($cookie['Name'] === 'XSRF-TOKEN') {
                    $xsrfToken = urldecode($cookie['Value']);
                    break;
                }
            }
        }

        return $xsrfToken;
    }

    /**
     * Perform a request with CSRF protection like a browser (using X-XSRF-TOKEN header).
     * Optionally specify which page to fetch the XSRF token from (default: /register).
     */
    protected function requestWithXsrf($method, $uri, array $formParams, $getPage = '/register')
    {
        $xsrfToken = $this->getXsrfToken($getPage);
        return $this->client->request($method, $uri, [
            'form_params' => $formParams,
            'headers' => [
                'X-XSRF-TOKEN' => $xsrfToken,
            ],
            'allow_redirects' => false,
        ]);
    }

    /**
     * Convenience wrapper for POST requests with XSRF token.
     */
    protected function postWithXsrf($uri, array $formParams, $getPage = '/register')
    {
        return $this->requestWithXsrf('POST', $uri, $formParams, $getPage);
    }
} 