<?php

use App\Models\User;

test('login screen can be rendered', function () {
    $response = $this->client->get('/login');

    $this->assertEquals(200, $response->getStatusCode());
});

test('users can authenticate using the login screen', function () {
    $user = User::factory()->create();

    $response = $this->postWithXsrf('/login', [
        'email' => $user->email,
        'password' => 'password',
    ], '/login');

    $this->assertEquals(302, $response->getStatusCode());
    $this->assertStringContainsString('/dashboard', $response->getHeaderLine('Location'));
});

test('users can not authenticate with invalid password', function () {
    $email = 'integration_' . uniqid() . '@example.com';
    $password = 'password';

    $this->createTestUser($email, $password);
    $response = $this->postWithXsrf('/login', [
        'email' => $email,
        'password' => 'wrong-password',
    ], '/login');

    $this->assertEquals(302, $response->getStatusCode());
    $this->assertStringContainsString('/login', $response->getHeaderLine('Location'));
});

test('users can logout', function () {
    $email = 'integration_' . uniqid() . '@example.com';
    $password = 'password';

    $this->createTestUser($email, $password);
    $this->login($email, $password);
    $response = $this->postWithXsrf('/logout', [], '/');

    $this->assertEquals(302, $response->getStatusCode());
    $this->assertStringContainsString('/', $response->getHeaderLine('Location'));
}); 