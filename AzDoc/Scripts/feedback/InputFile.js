$('#fileClear').click(function () {
    $('#fileClear').hide();
    $('.image-preview-input input:file').val("");
    $("#imageTitle").text("Fayl seçin");
    $('.inpFile').remove();
    $("#fileNames").val('...');
});

$('#file').change(function () {
    $('#fileClear').hide();
    $('.inpFile').remove();
    $("#fileNames").val('...');
    $("#imageTitle").text("Fayl seçin");

    if (this.files.length > 0) {
        $("#fileClear").show();
        $('#imageTitle').text("Dəyiş");

        if (this.files.length === 1) {
            $("#fileNames").val(this.files.item(0).name);
        }
        else {
            var output = $('#name');
            var html = $('<ul class="inpFile list-group">');
            for (var i = 0; i < this.files.length; ++i) {
                var inp = $('<li class=" list-group-item list-group-item-success">' + this.files.item(i).name + '</li>');
                //<a style="color:brown" class="glyphicon glyphicon-remove pull-right" onclick="removeFile(this);"></a>
                html.append(inp);
                //array.push(this.files.item(i).name);
            }
            html.append('</ul>');
            $(output).append(html);

            $("#fileNames").val(this.files.length + ' fayl seçilib');
        }
    }
});

function removeFile(e) {
    var fileItem = $(e).parent('li');
    var i = fileItem.index();
    fileItem.remove();
}