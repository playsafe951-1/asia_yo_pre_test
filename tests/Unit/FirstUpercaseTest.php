<?php

namespace Tests\Unit;

use App\Rules\FirstUppercase;
use Log;
use PHPUnit\Framework\TestCase;

class FirstUpercaseTest extends TestCase
{
    /**
     * A basic unit test example.
     */
    public function test_example(): void
    {
        $rule = new FirstUppercase;

        $rule->validate("name", "Test", function ($s) {
            $this->assertTrue($s == null);
        });

        $rule->validate("name", "test", function ($s) {
            $this->assertTrue($s == ":attribute is not capltalized");
        });
    }
}
