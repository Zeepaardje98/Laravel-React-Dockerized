<?php

test('registration screen can be rendered', function () {
    $response = $this->client->get('/register');

    $this->assertEquals(200, $response->getStatusCode());
});

test('new users can register', function () {
    $response = $this->requestWithXsrf('POST', '/register', [
        'name' => 'Test User',
        'email' => 'integration_' . uniqid() . '@example.com',
        'password' => 'password',
        'password_confirmation' => 'password',
    ], '/register');

    $this->assertEquals(302, $response->getStatusCode());
    $this->assertStringContainsString('/dashboard', $response->getHeaderLine('Location'));
});

// php artisan test --filter=RegistrationTest