<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Testing\Fluent\AssertableJson;
use Tests\TestCase;

class OrderNameTest extends TestCase
{
    /**
     * A basic feature test example.
     */
    public function test_order_name_first_upercase(): void
    {
        $response = $this->post('/api/orders', $this->orderData(['name' => "name"]));

        $response->assertStatus(400);

        $response = $this->post('/api/orders', $this->orderData(["name" => "Name name"]));

        $response->assertStatus(400)->assertJson(function (AssertableJson $json) {
            $json->has('errors')->where("errors.0", "Name is not capitalized");
        });
    }

    public function test_order_name_(): void
    {
        $response = $this->post('/api/orders', $this->orderData(['name'=>'^&*']));

        $response->assertStatus(400)->assertJson(function (AssertableJson $json) {
            $json->has('errors')->where("errors.0", "Name contains non-English characters");
        });
    }
}
