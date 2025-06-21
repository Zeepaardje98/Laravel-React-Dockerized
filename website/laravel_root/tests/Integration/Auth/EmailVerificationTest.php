<?php

test('email verification screen can be rendered', function () {
    $email = 'integration_' . uniqid() . '@example.com';
    $password = 'password';

    $this->createTestUser($email, $password);
    $this->login($email, $password);

    $response = $this->client->get('/verify-email');

    $this->assertEquals(200, $response->getStatusCode());
});


test('email can be verified', function () {
    // This test would require generating a signed verification URL and simulating the verification process.
    $this->markTestIncomplete('Email verification flow requires signed URL and event simulation.');
});


test('email is not verified with invalid hash', function () {
    // This test would require generating an invalid signed verification URL and simulating the process.
    $this->markTestIncomplete('Email verification flow requires signed URL and event simulation.');
}); 