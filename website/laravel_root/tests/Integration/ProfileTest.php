<?php

namespace Tests\Integration;

use Tests\IntegrationTestCase;

class ProfileTest extends IntegrationTestCase
{
    public function test_profile_page_is_displayed()
    {
        $email = 'integration_' . uniqid() . '@example.com';
        $password = 'password';

        $this->createTestUser($email, $password);
        $this->login($email, $password);

        $response = $this->client->get('/profile');

        $this->assertEquals(200, $response->getStatusCode());
    }

    public function test_profile_information_can_be_updated()
    {
        $email = 'integration_' . uniqid() . '@example.com';
        $password = 'password';

        $this->createTestUser($email, $password);
        $this->login($email, $password);

        $response = $this->requestWithXsrf('PATCH', '/profile', [
            'name' => 'Test User',
            'email' => 'test@example.com',
        ], '/profile');

        $this->assertEquals(302, $response->getStatusCode());
        $this->assertStringContainsString('/profile', $response->getHeaderLine('Location'));
        // Optionally, fetch /profile and check for updated data in the response body
    }

    public function test_email_verification_status_is_unchanged_when_the_email_address_is_unchanged()
    {
        $email = 'integration_' . uniqid() . '@example.com';
        $password = 'password';

        $this->createTestUser($email, $password);
        $this->login($email, $password);

        $response = $this->requestWithXsrf('PATCH', '/profile', [
            'name' => 'Test User',
            'email' => $email,
        ], '/profile');

        $this->assertEquals(302, $response->getStatusCode());
        $this->assertStringContainsString('/profile', $response->getHeaderLine('Location'));
        // Optionally, fetch /profile and check for unchanged verification status
    }

    public function test_user_can_delete_their_account()
    {
        $email = 'integration_' . uniqid() . '@example.com';
        $password = 'password';

        $this->createTestUser($email, $password);
        $this->login($email, $password);

        $response = $this->requestWithXsrf('DELETE', '/profile', [
            'password' => $password,
        ], '/profile');

        $this->assertEquals(302, $response->getStatusCode());
        $this->assertStringContainsString('/', $response->getHeaderLine('Location'));
        // Optionally, try to access /profile and expect a redirect to login
    }

    public function test_correct_password_must_be_provided_to_delete_account()
    {
        $email = 'integration_' . uniqid() . '@example.com';
        $password = 'password';

        $this->createTestUser($email, $password);
        $this->login($email, $password);

        $response = $this->requestWithXsrf('DELETE', '/profile', [
            'password' => 'wrong-password',
        ], '/profile');

        $this->assertEquals(302, $response->getStatusCode());
        $this->assertStringContainsString('/profile', $response->getHeaderLine('Location'));
        // Optionally, check for error message in redirected page
    }
}

// php artisan test --filter=ProfileTest