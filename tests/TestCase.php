<?php

namespace Tests;

use Illuminate\Foundation\Testing\TestCase as BaseTestCase;

abstract class TestCase extends BaseTestCase
{

    function orderData(array $arr = [])
    {
        return array_merge([
            "id"       => "A0000001",
            "name"     => "Name",
            "address"  => [
                "city"     => "taipei-city",
                "district" => "da-an-district",
                "street"   => "fuxing-south-road"
            ],
            "price"    => 2000,
            "currency" => "TWD"
        ], $arr);
    }

}
