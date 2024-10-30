<?php
namespace App\Services;

use Illuminate\Support\Str;
interface OrderValidatorInterface
{
    public function validate(array $data): array;
}

class OrderValidator implements OrderValidatorInterface
{
    public function validate(array $data): array
    {
        $errors = [];

        // Name validation
        if (preg_match('/^[a-zA-Z ]+$/', $data['name']) === 0) {
            $errors[] = 'Name contains non-English characters';
        }
        
        if (Str::title($data['name']) !== $data['name']) {
            $errors[] = 'Name is not capitalized';
        }

        // Price validation
        if ($data['price'] > 2000) {
            $errors[] = 'Price is over 2000';
        }

        // Currency validation
        if (!in_array($data['currency'], ["TWD", "USD"])) {
            $errors[] = 'Currency format is wrong';
        }

        return $errors;
    }
}
