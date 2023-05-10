<?php

namespace App\Services\Settings\Company;

use App\Models\Branch;

class BranchService
{
    public function getData($request)
    {
        $search = $request->search;

        // Get company
        $query = Branch::with(['npwp_list_detail']);

        // Filter By Params
        $query->when(request('search', false), function ($q) use ($search) {
            $q->where('name', 'like', '%' . $search . '%');
        });

        return $query->paginate(10);
    }

    public function storeBranch($request)
    {
        $input = $request->only(['name', 'address', 'city', 'state', 'zip_code', 'latitude','status', 'longitude', 'radius','manager','tanggal','type','nohp','tanggal_akhir']);

        $branch = Branch::create($input);

        return $branch;
    }

    public function updateBranch($id, $request)
    {
        $input = $request->only(['name', 'address', 'city', 'state', 'zip_code', 'latitude','status', 'longitude', 'radius','manager','tanggal','type','nohp','tanggal_akhir']);

        $branch = Branch::findOrFail($id);
        $branch->update($input);

        return $branch;
    }

    public function deleteBranch($id)
    {
        $branch = Branch::findOrFail($id);
        $branch->delete();

        return $branch;
    }
}
