<form action="{{ route('test') }}" method="POST" enctype="multipart/form-data">
    @csrf
    <input type="file" name="filer" id="">
    <input type="submit" value="Upload">
</form>