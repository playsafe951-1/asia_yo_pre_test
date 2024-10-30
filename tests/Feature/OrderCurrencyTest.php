<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Testing\Fluent\AssertableJson;
use Tests\TestCase;

class OrderCurrencyTest extends TestCase
{
    /**
     * A basic feature test example.
     */
    public function test_order_currency_transfform(): void
    {
        $response = $this->post(
            '/api/orders',
            $this->orderData(['price' => 10, 'currency' => 'USD'])
        );

        $response->assertStatus(200)->assertJson([
            'price'    => 310,
            'currency' => 'TWD'
        ]);
    }

    function test_other_currency()
    {
        $response = $this->post('/api/orders', $this->orderData([
            "currency" => "TWDD"
        ]));

        $response->assertStatus(400)->assertJson(function (AssertableJson $json) {
            return $json->has('errors')->where('errors.0', 'Currency format is wrong');
        });
    }
}
