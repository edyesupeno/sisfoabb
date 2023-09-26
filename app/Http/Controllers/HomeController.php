<?php

namespace App\Http\Controllers;

class HomeController extends AdminBaseController
{
    function __construct()
    {
        $this->title = "ERP ABB | Dashboard";
        $this->path = "dashboard/index";
        $this->data = ["total" => "0"];
    }

    
}
