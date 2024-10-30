<?php
namespace App\Services;

class OrderService
{
    protected OrderValidatorInterface $validator;

    public function __construct(OrderValidatorInterface $validator)
    {
        $this->validator = $validator;
    }

    public function check(array $data): array
    {
        return $this->validator->validate($data);
    }

    public function transform(array $data): array
    {
        if ($data['currency'] === 'USD') {
            $data['currency'] = 'TWD';
            $data['price'] *= 31;
        }

        return $data;
    }
}
