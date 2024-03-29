<?php

namespace App\Http\Requests\Employee\Employee;

use Illuminate\Foundation\Http\FormRequest;

class ValidateBasicInfoRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, mixed>
     */
    public function rules()
    {
        if($this->action === 'update'){
            $pictureRule = 'nullable|file|max:3072|mimes:jpg,jpeg,png';
            $phoneNumberRule = 'required|string|unique:employees,id,' . $this->id;
            $emailRule = 'required|email|unique:users,email,' . $this->user_id;
            $password = '';
            $role = '';
        }else{
            $pictureRule = 'required|file|max:3072|mimes:jpg,jpeg,png';
            $phoneNumberRule = 'required|string|unique:employees';
            $emailRule = 'required|email|unique:users';
            $password = 'required|confirmed|min:6';
            $role = 'required|exists:roles,id';
        }

        return [
            'picture' => $pictureRule,
            'employee_name' => 'required|string',
            'email' => $emailRule,
            'phone_number' => $phoneNumberRule,
            'employee_external_id' => 'nullable|string',
            'password' => $password,
            'designation_id' => 'required|exists:designations,id',
            'role_id' => $role,
            'address' => 'required|string',
            'user_device' => 'nullable|string'
        ];
    }
}
