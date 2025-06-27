<?php

namespace Tests;

use GuzzleHttp\Client;
use GuzzleHttp\Cookie\CookieJar;
use App\Models\User;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\DB;
use Illuminate\Foundation\Testing\DatabaseTruncation;
use Illuminate\Foundation\Testing\TestCase as BaseTestCase;

abstract class IntegrationTestCase extends BaseTestCase
{
    use DatabaseTruncation;

    protected $client;
    protected static $migrated = false;

    protected function setUp(): void
    {
        parent::setUp();

        // Ensure integration tests only run in testing environment
        if (config('app.env') !== 'testing') {
            $this->markTestSkipped('Integration tests can only run in testing environments, as they truncate the main 
                                    database. Current environment: ' . config('app.env'));
        }

        // Set up the database by migrating it once for all integration tests.
        if (!static::$migrated) {
            \Illuminate\Support\Facades\Artisan::call('migrate:fresh');
            static::$migrated = true;
        }

        // For each test, create a new client with refreshed cookiejar
        $this->client = new Client([
            'base_uri' => env('APP_URL', 'https://localhost'),
            'verify' => false,
            'cookies' => new CookieJar(),
        ]);
    }

    protected function tearDown(): void
    {
        parent::tearDown();
    }


    /**
     * HTTP request builder for integration tests.
     */
    protected function httpRequestBuilder()
    {
        return new class($this->client) {
            private $client;
            private $pendingRequest = [];
            private $xsrfToken = null;

            public function __construct($client)
            {
                $this->client = $client;
            }

            public function get($uri, $params = [])
            {
                $this->pendingRequest = [
                    'method' => 'GET',
                    'uri' => $uri,
                    'params' => $params,
                ];
                return $this;
            }

            public function post($uri, $params = [])
            {
                $this->pendingRequest = [
                    'method' => 'POST',
                    'uri' => $uri,
                    'params' => $params,
                ];
                return $this;
            }

            public function patch($uri, $params = [])
            {
                $this->pendingRequest = [
                    'method' => 'PATCH',
                    'uri' => $uri,
                    'params' => $params,
                ];
                return $this;
            }

            public function put($uri, $params = [])
            {
                $this->pendingRequest = [
                    'method' => 'PUT',
                    'uri' => $uri,
                    'params' => $params,
                ];
                return $this;
            }

            public function delete($uri, $params = [])
            {
                $this->pendingRequest = [
                    'method' => 'DELETE',
                    'uri' => $uri,
                    'params' => $params,
                ];
                return $this;
            }

            private function getXsrfToken()
            {
                // Use lightweight route to set CSRF token cookie
                $response = $this->client->get('/test/csrf-token');
                
                $data = json_decode($response->getBody(), true);

                return $data['csrf_token'] ?? null;
            }

            public function withXsrf()
            {
                // Get xsrf token only when it doesn't exist yet to avoid making unnecessary HTTP requests.
                $this->xsrfToken = $this->getXsrfToken();
                return $this;
            }

            public function actingAs($user, $password = 'password')
            {
                // Log in the user
                $response = $this->withXsrf()->post('/login', [
                    'email' => $user->email,
                    'password' => $password,
                ])();

                if ($response->getStatusCode() !== 302) {
                    throw new \Exception('Login failed for user: ' . $user->email);
                }

                // Get new xsrf token after authentication
                $this->xsrfToken = $this->getXsrfToken();

                return $this;
            }

            public function send()
            {
                if (!isset($this->pendingRequest['method']) || !isset($this->pendingRequest['uri'])) {
                    throw new \Exception('HTTP method and URI must be set before calling getResponse().');
                }

                $method = $this->pendingRequest['method'];
                $uri = $this->pendingRequest['uri'];
                $params = $this->pendingRequest['params'] ?? [];

                $options = [
                    'allow_redirects' => false,
                ];

                if (in_array($method, ['POST', 'PATCH', 'PUT', 'DELETE'])) {
                    $options['form_params'] = $params;
                } else {
                    $options['query'] = $params;
                }

                if ($this->xsrfToken) {
                    $options['headers']['X-CSRF-TOKEN'] = $this->xsrfToken;
                }

                // error_log('sending request to ' . $uri);
                // error_log('method: ' . $method);
                // error_log('xsrfToken sent with request: ' . $this->xsrfToken);

                $response = $this->client->request($method, $uri, $options);

                // Reset only the builder's request
                $this->pendingRequest = [];

                return $response;
            }

            public function __invoke()
            {
                return $this->send();
            }
        };
    }
} 