// Faylin secilmesi
$(function () {
    $('#btnBrowse').change(function (e) {
        if (this.files.length > 0) {
            var ext = this.files.item(0).name.split('.').pop().toLowerCase();
            if ($.inArray(ext, ['jpg', 'png', 'doc', 'docx', 'xlsx', 'xls', 'pdf']) === -1) {
                toastr.warning("Yalniz Word, Excel, PDF, JPG, PNG fayllar yüklənə bilər");
                $(this).val("");
            } else {
                if (this.files[0].size === 0) {
                    toastr.warning("Fayl boşdur. Zəhmət olmasa başqa bir fayl yükləyin");
                    $('#btnBrowse').val("");
                    return;
                }

                if (this.files[0].size < 200000000) { //200000000 200mb
                    if (this.files.length > 0) {
                        $("#fileNames").val(this.files.item(0).name);
                        UploadFileOnServer(e);
                    }
                }
                else {
                    $('#btnBrowse').val("");
                    toastr.warning("Faylın həcmi həddindən artıqdır. 200 Mb-a qədər həcmdə fayl yükləyə bilərsiz");
                }
            }
        }
    });
});

function removeFile(e) {
    var fileItem = $(e).parent('li');
    fileItem.remove();
}

//File secende acilan popup da okay edende isleyir
function UploadFileOnServer(e) {
    var files = e.target.files;
    var confirmText = files[0].name + " faylını yükləmək istəyirsinizmi?";

    Swal.fire({
        title: confirmText,
        type: 'warning',
        showCancelButton: true,
        allowOutsideClick: false,
        cancelButtonText: 'Ləğv et',
        confirmButtonText: 'Təsdiqlə'
    }).then((result) => {
        if (result.value) {
            UploadFileAjax(e);
        }
        else if (result.dismiss == 'cancel') {
            $("input[name='hFileInfoId']").val("");
            $('#btnBrowse').val("");
        }
    });
}

function PageCopyCount(element) { // nusxe ve vereq sayini daxil etmek ucun lazim olan modal
    var text = '<div class="container"><div class="row">' +
        '<div class="col"><span>Nüsxə:</span></div>' +
        '<div class="col"><input class="form-control" style="width:60px;margin-left:7px" type="number" oninput="validity.valid||(value=&quot;&quot;);" id="countCopy" value="1" min="1" autofocus></div>' +
        '<div class="col"><span>Vərəq:</span></div>' +
        '<div class="col"><input class="form-control" style="width:60px;margin-left:7px" type="number" oninput="validity.valid||(value=&quot;&quot;);" id="countPage" value="1" min="1"></div>' +
        '</div>' +
        '</div>';

    Swal.fire({
        title: text,
        showCancelButton: true,
        allowOutsideClick: false,
        cancelButtonText: 'Ləğv et',
        confirmButtonText: 'Təsdiqlə'
    }).then((result) => {
        if (result.value) {
            if ($('#countPage').val() !== "" && $('#countCopy').val() !== "") {
                UpdateFileInfo(element, $('#countPage').val(), $('#countCopy').val());
            } else {
                if ($('#countPage').val() === "") {
                    $('#countPage').css({ "border": "1px solid red" });
                    toastr.warning("Vərəq sayını daxil edin");
                }
                if ($('#countCopy').val() === "") {
                    $('#countCopy').css({ "border": "1px solid red" });
                    toastr.warning("Nüsxə sayını daxil edin");
                }
            }
        }
    });
}

function UpdateFileInfo(element, page, copy) {
    var value = $(element.parentElement.parentElement.childNodes[1].children[0]).val();

    $.ajax({
        url: '/az/File/FileInfoUpdate?fileInfoId=' + value + '&page=' + page + '&copy=' + copy,
        type: 'POST',
        success: function (data) {
            if (data === true) {
                $('#fakeButton').click();
                window.CloseLoading(); // ok- cavab gelenden sonra loading baglanir
            }
            else {
                // Handle errors here
                console.log('ERRORS: ' + data.error);
                toastr.error(data.error);
            }
        },
        error: function (textStatus) {
            toastr.error(textStatus);
            console.log('ERRORS: ' + textStatus);
        },
        cache: false,
        processData: false, // Don't process the files
        contentType: false // Set content type to false as jQuery will tell the server its a query string request
    });
}

function UploadFileAjax(e) {

    var files = e.target.files;
    var hFileInfoId = $("input[name='hFileInfoId']").val();
    var token = $('#spanToken').html();
    var subPathName = $('#hiddenActionName').val();
    var url = "";
    if (window.location.search == "" || subPathName != 'EditDocument')
        url = '/az/File/UploadFileAction?token=' + token + "&hFileInfoId=" + hFileInfoId;
    else
        url = '/az/File/UploadFileAction' + window.location.search + "&hFileInfoId=" + hFileInfoId;
    if (files.length > 0) {
        if (window.FormData !== undefined) {
            var data = new FormData();
            for (var x = 0; x < files.length; x++) {
                data.append("file" + x, files[x]);
            }
            e.preventDefault();
            $.ajax({
                url: url,
                type: 'POST',
                data: data,
                beforeSend: window.ShowLoading(),
                success: function (data) {
                    if (data !== -1) {
                        $("input[name='hFileInfoId']").val("");
                        $("#spanToken").html(data);
                        $('#fakeButton').click(); // CallBackUploadFilesPartial-i yeniliyir
                        SAlert.addSuccess();
                    } else {
                        SAlert.failed();
                    }
                },
                complete: function () {
                    $("#btnBrowse").val("");
                    window.CloseLoading();
                },
                cache: false,
                processData: false, // Don't process the files
                contentType: false // Set content type to false as jQuery will tell the server its a query string request
            });
        } else {
            window.warning("This browser doesn't support HTML5 file uploads!");
        }
    }
}

function DeleteFile(element) { // File silmek
    var fileInfoId = $(element).closest("tr").find("#fileInfoId").val(); // setirdeki file-in idsini goturur
    Swal.fire({
        title: 'Bu sətir cədvəldən silinəcək',
        type: 'warning',
        showCancelButton: true,
        allowOutsideClick: false,
        cancelButtonText: 'Ləğv et',
        confirmButtonText: 'Təsdiqlə'
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: '/az/File/DeleteFile?fileInfoId=' + fileInfoId,
                type: 'POST',
                dataType: "json",
                success: function (data) {
                    if (data) {
                        $('#fakeButton').click(); // table yenilenir
                        SAlert.deleteSuccess();
                    }
                    else {
                        // Handle errors here
                        SAlert.failed();
                        console.log('ERRORS: ' + data.error);
                    }
                },
                error: function (textStatus) {
                    SAlert.failed();
                    console.log('ERRORS: ' + textStatus);
                },

                cache: false,
                processData: false, // Don't process the files
                contentType: false // Set content type to false as jQuery will tell the server its a query string request
            });
        }
    });
}

//function GetAgreementModal(element) { // YENI VERSIYA
//    var fileInfoId = $(element).closest("tr").find("#fileInfoId").val(); // radiobutton secilende oldugu setirdeki senedin idsini
//    $("input[name='mainFileInfoId']").val(fileInfoId);

//    var select = $("#resPerson"); //RAZILASMA SXEMI ACILANDA MESUL SEXSI DOLDURUR
//    select.empty().append($("<option disabled>Seçin</option>").val("-1"));

//    $.ajax({
//        type: "GET",
//        url: "/az/File/GetResponsePerson",
//        contentType: "application/json; charset=utf-8",
//        dataType: "json",
//        success: function (response) {
//            $.each(response, function () {
//                select.append($("<option></option>").val(this.Id).html(this.Name));
//            });

//            $(".selectpicker").selectpicker('refresh');
//            $("#agreeModal").modal('show');
//        }
//    });

//    //AgreementSchemeGridPartial();
//};

//function AgreementSchemeGridPartial() {
//    $.get("/az/File/AgreementSchemeGridPartial?fileInfoId=" + $("input[name='mainFileInfoId']").val(), function (data) {
//        $("#agreeModalContent").html(data);
//        $("#agreeModal").modal('show');
//    });
//}

function DownloadFile(element) { // File-i yuklemek
    var fileInfoId = $(element).closest("tr").find("#fileInfoId").val(); // setirdeki file-in idsini goturur
    console.log(fileInfoId);
    window.location = "/az/File/DownloadFile?fileInfoId=" + fileInfoId;
}

function ChangeFile(element) { // File-i deyismek
    var fileInfoId = $(element).closest("tr").find("#fileInfoId").val(); // setirdeki file-in idsini goturur
    $("input[name='hFileInfoId']").val(fileInfoId);
    $('#btnBrowse').click();
}

//function AddNewVizaExecutors() {
//    var toPersonWorkPlaceId = $('#resPerson').val();
//    var orderIndex = $('#personOrderIndex').val();
//    var token = $("#spanToken").html();

//    if (token === "") {
//        token = window.location.search
//            .substring(window.location.search.lastIndexOf("token="), window.location.search.length)
//            .replace("token=", "");
//    }

//    if (toPersonWorkPlaceId != null && orderIndex !== "") {
//        if ($('#personOrderIndex').hasClass("is-invalid")) {
//            $('#personOrderIndex').removeClass("is-invalid").addClass("is-valid");
//        }
//        if ($('.dropdown.bootstrap-select.form-control').hasClass("is-invalid")) {
//            $('#personOrderIndex').removeClass("is-invalid").addClass("is-valid");
//        }

//        $.get("/az/File/AddNewVizaExecutors?toPersonWorkPlaceId=" + toPersonWorkPlaceId + "&orderIndex=" + orderIndex + "&token=" + token,
//            function (data) {
//                console.log(data);
//                if (data === 0)
//                    return toastr.warning("Qrup nömrəsini düzgün daxil edin.");
//                else if (data === 1)
//                    return toastr.warning("Əvvəlcə qurum rəhbərini vizaya əlavə edin.");
//                else if (data === -1)
//                    return toastr.warning("Xəta baş verdi.");
//                AgreementSchemeGridPartial();
//                $('#personOrderIndex').val("");
//                $("#resPerson").children('[value="-1"]').prop("selected", true);
//                $("#resPerson").selectpicker('refresh');
//                //$('select >option[value="430"]').prop("selected", true);
//            });
//    } else {
//        if (orderIndex === "") {
//            $('#personOrderIndex').addClass("is-invalid");
//            toastr.warning('" Qrup № "-ni daxil edin');
//        }
//    }
//}

//function DeleteViza(vizaId) {
//    Swal.fire({
//        title: 'Bu sətir cədvəldən silinəcək',
//        type: 'warning',
//        showCancelButton: true,
//        allowOutsideClick: false,
//        cancelButtonText: 'Ləğv et',
//        confirmButtonText: 'Təsdiqlə'
//    }).then((result) => {
//        if (result.value) {
//            $.ajax({
//                type: "POST",
//                url: "/az/File/VizaDelete?vizaId=" + vizaId,
//                contentType: "application/json; charset=utf-8",
//                dataType: "json",
//                success: function (data) {
//                    console.log(data);
//                    if (data === 1) {
//                        $("#deleteViza").modal('hide');
//                        SAlert.deleteSuccess();
//                        //AgreementSchemeGridPartial();
//                    } else {
//                        SAlert.failed();
//                    }
//                },
//                failure: function (response) {
//                    toastr.warning(response.responseText);
//                },
//                error: function (response) {
//                    toastr.error(response.responseText);
//                }
//            });
//        }
//    });
//}