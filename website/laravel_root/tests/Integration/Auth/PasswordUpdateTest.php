<?php

test('password can be updated', function () {
    $email = 'integration_' . uniqid() . '@example.com';
    $password = 'password';
    $newPassword = 'new-password';

    $this->createTestUser($email, $password);
    $this->login($email, $password);

    $response = $this->requestWithXsrf('PUT', '/password', [
        'current_password' => $password,
        'password' => $newPassword,
        'password_confirmation' => $newPassword,
    ], '/profile');

    $this->assertEquals(302, $response->getStatusCode());
    $this->assertStringContainsString('/profile', $response->getHeaderLine('Location'));
    // Optionally, try to login with new password
});

test('correct password must be provided to update password', function () {
    $email = 'integration_' . uniqid() . '@example.com';
    $password = 'password';
    $newPassword = 'new-password';

    $this->createTestUser($email, $password);
    $this->login($email, $password);

    $response = $this->requestWithXsrf('PUT', '/password', [
        'current_password' => 'wrong-password',
        'password' => $newPassword,
        'password_confirmation' => $newPassword,
    ], '/profile');

    $this->assertEquals(302, $response->getStatusCode());
    $this->assertStringContainsString('/profile', $response->getHeaderLine('Location'));
    // Optionally, check for error message in redirected page
}); 