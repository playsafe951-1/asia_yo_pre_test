<?php

namespace App\Http\Requests;

use App\Currency;
use App\Rules\FirstUppercase;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class OrdersRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            "name"     => ["required", "string"],
            "price"    => "required|integer",
            "currency" => ["required", "string"]
        ];
    }

    function attributes()
    {
        return [
            "name"     => "Name",
            "price"    => "Price",
            "currency" => "Currency"
        ];
    }
    
}


// class OrdersRequest extends FormRequest
// {
//     /**
//      * Determine if the user is authorized to make this request.
//      */
//     public function authorize(): bool
//     {
//         return true;
//     }

//     /**
//      * Get the validation rules that apply to the request.
//      *
//      * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
//      */
//     public function rules(): array
//     {
//         return [
//             "name"=>["required","string","regex:/^[a-zA-Z ]+$/",new FirstUppercase()],
//             "price"=>"required|integer|min:1|max:2000",
//             "currency"=>["required","string",Rule::enum(Currency::class) ]
//         ];
//     }

//     function attributes() {
//         return [
//             "name" => "Name",
//             "price" => "Price",
//             "currency" => "Currency"
//         ];
//     }

//     function messages(){
//         return [
//             // 名稱
//             "name.regx" => ":attribute contains non-English characters",
//             "name.App\Rules\FirstUppercase"=>":attribute is not capltalized",
//             // todo字首規則
//             // 價格
//             "price.max" => ":attribute is over 2000",
//             // 幣別
//             "currency.Illuminate\Validation\Rules\Enum" => ":attribute format is wrong"
//         ];
//     }

//     function passedValidation(){
//         if($this->currency == "USD") {
//             $this->merge([
//                 "currency" => "TWD",
//                 "price" => $this->price * 31
//             ]);
//         }
//     }
// }

