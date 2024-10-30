<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Testing\Fluent\AssertableJson;
use Tests\TestCase;

class OrderPriceTest extends TestCase
{
    /**
     * A basic feature test example.
     */
    public function test_order_price(): void
    {
        $response = $this->post('/api/orders', $this->orderData(['price'=>2000]));

        $response->assertStatus(200);
    }

    function test_order_price_over(){
        $response = $this->post('/api/orders', $this->orderData(['price'=>2001]));

        $response->assertStatus(400)->assertJson(function(AssertableJson $json){
            return $json->has('errors')->where('errors.0','Price is over 2000');
        });
    }
}
