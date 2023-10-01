<?php

namespace App\Http\Resources\Attendances\Attendance;

use Illuminate\Http\Resources\Json\ResourceCollection;

class AttendanceListResource extends ResourceCollection
{
    /**
     * Transform the resource collection into an array.
     *
     * @param  \Illuminate\Http\Request
     * @return array
     */
    public function toArray($request)
    {
        return [
            'data' => $this->collection['attendances'],
            'meta' => [
                "success" => true,
                "message" => "Success get attendance lists",
                'pagination' => $this->metaData()
            ]
        ];
    }

    private function metaData()
    {
        return [
            "total" => $this->total(),
            "count" => $this->count(),
            "per_page" => (int)$this->perPage(),
            "current_page" => $this->currentPage(),
            "total_pages" => $this->lastPage(),
            "links" => [
                "next" => $this->nextPageUrl()
            ],
        ];
    }
}
