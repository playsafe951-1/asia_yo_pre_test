<?php

namespace App\Http\Controllers;

use App\Http\Requests\OrdersRequest;

use App\Services\OrderService;
use Illuminate\Http\Request;

class OrderController extends Controller
{
    function Orders(OrdersRequest $request, OrderService $s)
    {

        $errors = $s->check($request->all());
        if (!empty($errors))
            return response()->json([
                "errors" => $errors
            ],400);

        $transformedData = $s->transform($request->all());

        return $transformedData;
    }
}
