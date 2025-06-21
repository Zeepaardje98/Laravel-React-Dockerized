<?php

test('confirm password screen can be rendered', function () {
    $email = 'integration_' . uniqid() . '@example.com';
    $password = 'password';

    $this->createTestUser($email, $password);
    $this->login($email, $password);

    $response = $this->client->get('/confirm-password');

    $this->assertEquals(200, $response->getStatusCode());
});


test('password can be confirmed', function () {
    $email = 'integration_' . uniqid() . '@example.com';
    $password = 'password';

    $this->createTestUser($email, $password);
    $this->login($email, $password);

    $response = $this->postWithXsrf('/confirm-password', [
        'password' => $password,
    ], '/confirm-password');

    $this->assertEquals(302, $response->getStatusCode());
});


test('password is not confirmed with invalid password', function () {
    $email = 'integration_' . uniqid() . '@example.com';
    $password = 'password';

    $this->createTestUser($email, $password);
    $this->login($email, $password);

    $response = $this->postWithXsrf('/confirm-password', [
        'password' => 'wrong-password',
    ], '/confirm-password');

    $this->assertEquals(302, $response->getStatusCode());
}); 