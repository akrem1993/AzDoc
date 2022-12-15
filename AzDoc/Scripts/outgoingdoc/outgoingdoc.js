// Extension Table to Json
(function ($) {
    $.fn.getFormData = function () {
        var arr = $(this).serializeArray();
        var obj = new Object();
        $(arr).each(function (index, item) {
            obj[item.name] = item.value;
        });

        return obj;
    };

    $.fn.jsonFormData = function () {
        return JSON.stringify($(this).getFormData());
    };

    $.fn.tableToJsonList = function () {
        var table = $(this);
        var list = [];
        $(table).find('tr.rowSelector').each(function (trindex, tr) {
            list.push($(tr).data());
        });
        return list;
    }
}(jQuery));


$(document).on("click",
    ".popoverAction",
    function () {

        var actionId = this.id;
        var requestToken = $("#spanToken").html();
        var elementDocId = $("#DocActionsPopover").attr('class');
        if (actionId == 1) {
            console.log(1)
            Swal.fire({
                title: 'Sənədin göndərilməsinə əminsiniz?',
                type: 'warning',
                showCancelButton: true,
                cancelButtonText: 'Ləğv et',
                confirmButtonText: 'Təsdiqlə'
            }).then((result) => {
                if (result.value) {
                    $.ajax({
                        type: 'POST',
                        url: config.actionOperation.url.buildUrl({ token: requestToken }),
                        data: { actionId: actionId },
                        beforeSend: function () {
                            window.ShowLoading();
                        },
                        success: function () {
                            var pageIndex = $('#gridOutgoingDoc').CachedGrid().config.params.pageIndex;
                            $('#gridOutgoingDoc').bindgrid(pageIndex, undefined);
                        },
                        complete: function () {
                            window.CloseLoading();
                        }

                        // $(location).attr('href', config.indexOperation.url);
                    });
                }
            });
        }
        else if (actionId == 21) {
            console.log(elementDocId);
            $.ajax({
                url: config.blankOperation.url.buildUrl({ token: requestToken }),
                type: 'GET',
                data: { docId: elementDocId },
                dataType: 'html',
                beforeSend: function () { window.ShowLoading(); },
                success: function (response) {
                    window.CloseLoading();
                    console.log('enter');
                    $('#dynamiccontext').html(response);
                },
                error: function (response) {
                    console.log(response);
                }
            });

        }
        else {
            $.ajax({
                type: 'POST',
                url: config.actionOperation.url.buildUrl({ token: requestToken }),
                data: { actionId: actionId },
                success: function (actionOperation) {
                    if (typeof actionOperation == 'object') {
                        //DocumentModel
                        if (actionOperation.ActionId == 8) {
                            $.ajax({
                                url: config.directionOperation.url + actionOperation.DocId,
                                type: 'GET',
                                dataType: 'html',
                                beforeSend: function () { window.ShowLoading(); },
                                success: function (response) {
                                    $('#dynamiccontext').html(response);
                                },
                                error: function (response) {
                                    console.log(response);
                                }
                            });
                        }
                    }
                    else {
                        if (actionOperation == 2) {
                            config.editOperation.data = requestToken;
                            $(location).attr('href', config.editOperation.url.buildUrl({ token: requestToken }));

                        } else if (actionOperation == 4) {
                            SendForInformaton(requestToken);
                        }
                        else if (actionOperation == 15) {
                            var pageIndex = $('#gridOutgoingDoc').CachedGrid().config.params.pageIndex;
                            $('#gridOutgoingDoc').bindgrid(pageIndex, undefined);
                        }
                        else if (actionOperation == 16) {
                            $('.modalBtn').modal('show');
                            //$(location).attr('href', config.indexOperation.url);
                        }

                    }

                }
            });
        }

    });

function onRowDoubleClick(event, rowdata) {
    window.ShowLoading();
    $("#globalDocId").val(rowdata.DocId);
    config.electronicDoc.data.docId = rowdata.DocId;
    config.electronicDoc.data.executorId = rowdata.ExecutorId;
    config.infoOperation.data.docId = rowdata.DocId;


    $.ajax({
        type: 'GET',
        url: config.electronicDoc.url,
        dataType: 'html',
        data: config.electronicDoc.data,
        beforeSend: function () { window.ShowLoading(); },
        success: function (response) {
            $('#ElectronicDocument').html(response);
            $(`[title='${rowdata.DocId}']`).closest('[role="row"]').removeClass('unread');
            $("#doubleClickModal").modal();
            console.log(config.infoOperation.url);
            $.ajax({
                type: 'GET',
                url: config.infoOperation.url,
                dataType: 'json',
                data: config.infoOperation.data,
                success: function (result) {
                    if (result != '') {
                        $.ajax({
                            type: 'GET',
                            url: '/az/Document/GetDocView'.buildUrl({ token: result }),
                            dataType: 'html',
                            success: function (docInfoView) {
                                window.CloseLoading();
                                $('#DocInfo').html(docInfoView);
                            }
                        });
                    }
                },
                complete: function () {
                    window.CloseLoading();
                }
            });
        },
        complete: function () {
            window.CloseLoading();
        }
    });

}

function DocView(item, boundData) {
    console.log(config.infoOperation.url);
    $.ajax({
        type: 'GET',
        url: config.infoOperation.url,
        dataType: 'json',
        data: { docId: boundData.DocId },
        success: function (result) {
            if (result != '') {
                window.open('/az/Document/GetDocView'.buildUrl({ token: result }), '_blank');
            }
        },
        complete: function () {
            window.CloseLoading();
        }
    });
}


function checkUnread(boundData) {
    return boundData.ExecutorControlStatus === false;
}

function ActionClick(item, boundData) {
    $.ajax({
        type: 'GET',
        url: config.actnameOperation.url,

        dataType: 'html',
        data: { docId: boundData.DocId, menuTypeId: 0, executorId: boundData.ExecutorId },
        success: function (data) {
            $(item).popover({
                html: true,
                content: data,
                container: "html",
                trigger: "focus"

            });
            $(item).popover('show');
        },
        fail: function (result) {
            console.log(response);
        }
    });
}


$('.custom').editableSelect();

$('.custom').on("keypress",
    function (event) {
        if (event.which == 13) {
            var value = $(this).val(); // daxil etdiyimiz data
            if (value.length < 3) {
                return toastr.warning("Axtarış üçün ən azı 3 simvol daxil edin");
            }
            $("#searchAuthor").val() === "" ? $("#labelForAddNewAuthorModal").hide() : "";
            var ul = $(this.parentElement).find(".es-list");
            var nextInput = $(this).next();// hansi melumati cekmek istediyimizi qeyd edirik
            $.ajax({
                url: "/az/Document/GetAuthorInfo",
                type: 'POST',
                data: { data: value, next: nextInput.val() },
                beforeSend: function () {
                    window.ShowLoading();
                },
                success: function (data) {
                    console.log(data);
                    if (data.length === 0 && value !== "") {
                        var message;
                        switch (nextInput.val()) {
                            case "1":
                                message = "Təşkilatın adı siyahıda tapılmadı.";
                                break;
                            case "2":
                                message = "Şöbənin adı siyahıda tapılmadı.";
                                break;
                            case "3":
                                message = "Vəzifənin adı siyahıda tapılmadı.";
                                break;
                            case "4":
                                message = "Müəllif siyahıda tapılmadı.";
                                $('#labelForAddNewAuthorModal').css("display", "block");
                                break;
                            default:
                                message = "Axtarılan məlumat tapılmadı";
                                break;
                        }

                        ul.empty();
                        $(nextInput).next().val("");
                        toastr.warning(message);
                        return;
                    }
                    ul.empty();
                    if (nextInput.val() === "4" && value !== "") { // kimden daxil olub
                        ul.append('<li style="background-color:#267cad;font-style:bold;display:block;color:white" disabled>' +
                            '<div class="row" style="text-align:center">' +
                            '<div class="col-3">Təşkilat</div>' +
                            //'<div class="col-3">Ad</div>' +
                            //'<div class="col-3">Şöbə</div>' +
                            //'<div class="col-3">Vəzifə</div>' +
                            '</div>' +
                            '</li>');

                        $.each(data,
                            function () {
                                ul.append('<li value="' + this.AuthorOrganizationId + '" onmousedown="AddAuthorToDataTable(this)" class="es-visible" style="display: block;">' +
                                    '<div class="row">' +
                                    //'<div class="col-3" hidden>' + this.AuthorId + '</div>' +
                                    '<div class="col-3" hidden>' + this.AuthorOrganizationId + '</div>' +
                                    '<div class="col-3">' + (this.OrganizationName == null ? "---" : this.OrganizationName) + '</div>' +
                                    //'<div class="col-3">' + (this.FullName == null ? "---" : this.FullName) + '</div>' +
                                    //'<div class="col-3">' + (this.AuthorDepartmentName == null ? "---" : this.AuthorDepartmentName) + '</div>' +
                                    //'<div class="col-3">' + (this.PositionName == null ? "---" : this.PositionName) + '</div>' +
                                    '</div>' +
                                    '</li>'
                                );
                            });
                        //}
                    }
                    else if (nextInput.val() === "5" && value !== "") { // elaqeli sened
                        ul.append('<li style="background-color:#267cad;font-style:bold;display:block;color:white" disabled>' +
                            '<div class="row" style="text-align:center">' +
                            '<div class="col-3">Sənədin nömrəsi</div>' +
                            '<div class="col-3">Sənədin məlumatı</div>' +
                            '</div>' +
                            '</li>');

                        $.each(data,
                            function () {
                                ul.append('<li value="' + this.AuthorId + '" onmousedown="AddRelDocToDataTable(this)" class="es-visible" style="display: block;">' +
                                    '<div class="row">' +
                                    '<div class="col-3" hidden>' + this.AuthorId + '</div>' +
                                    '<div class="col-4">' + this.OrganizationName + '</div>' +
                                    '<div class="col-8">' + (this.FullName == null ? "---" : this.FullName) + '</div>' +
                                    '<div hidden>' + this.Token + '</div>' +
                                    '</div>' +
                                    '</li>'
                                );
                            });
                    }

                    else if (nextInput.val() === "6" && value !== "") { // cavab senedi
                        ul.append('<li style="background-color:#267cad;font-style:bold;display:block;color:white" disabled>' +
                            '<div class="row" style="text-align:center">' +
                            '<div class="col-3">Sənədin nömrəsi</div>' +
                            '<div class="col-3">Sənədin məlumatı</div>' +
                            '</div>' +
                            '</li>');

                        $.each(data,
                            function () {
                                console.log(this.AuthorId);
                                ul.append('<li value="' + this.AuthorId + '" onmousedown="AddAnswerDocToDataTable(this)" class="es-visible" style="display: block;">' +
                                    '<div class="row">' +
                                    '<div class="col-3" hidden>' + this.AuthorId + '</div>' +
                                    '<div class="col-4">' + this.OrganizationName + '</div>' +
                                    '<div class="col-8">' + (this.FullName == null ? "---" : this.FullName) + '</div>' +
                                    '<div class="col-3" hidden>' + this.AuthorOrganizationId + '</div>' +
                                    '<div hidden>' + this.Token + '</div>' +
                                    '</div>' +
                                    '</li>'
                                );
                            });
                    }
                    else {  // muellifin daxil edilmesi paneli ucun
                        $.each(data,
                            function () {
                                ul.append('<li value="' + this.AuthorId + '" onmousedown="SetOptionsId(this)" class="es-visible" style="display: block;">' + this.FullName + '</li>');
                            });
                    }
                    ul.show();
                },
                complete: function () {
                    window.CloseLoading();
                },
                error: function (jqXhr, textStatus, errorThrown) {
                    ul.empty();
                    window.CloseLoading();
                    toastr.error("Xəta baş verdi.");
                    console.log('jqXhr: ' + jqXhr + '; textStatus: ' + textStatus + '; errorThrown: ' + errorThrown);
                }
            });
        }
    });



function AddRelDocToDataTable(element) {
    var div = $(element).find("div");
    var dubCount = 0;
    var count = $('#relatedDocTable').find('.data-row').length;

    $.each($("#relatedDocTable tr"),
        function () {
            var docId = $(this).attr('data-DocId');
            console.log(docId);

            if (div[1].innerText == docId) {
                dubCount++;
            }
        });

    if (dubCount != 0) {
        toastr.warning('Bu sənəd artıq əlavə olunub');
        $(element.closest('ul')).html("");
        $('#searchRelatedDoc').val("");
        return;
    }

    var tr = "<tr id='tr' class='data-row rowSelector'" + "data-DocId='" + div[1].innerText + "'>" +
        //"<td style='text-align:center!important;font-weight:bold'>" + (++count) + "</td>" +
        "<td style='display:none'>" + div[1].innerText + "</td>" +
        "<td style='text-align:center!important'><a href='/az/Document/GetDocView?token=" + div[4].innerText + "' target='_blank'>" + div[2].innerText + "</a></td>" +
        "<td style='text-align:center!important'>" + div[3].innerText + "</td>" +
        "<td style='text-align:center!important'>" +
        "<a onclick='deleteRowDataTable(this)' id='deleteRowDataTable' class='remove'>" +
        "<span class='fas fa-trash-alt btn' style='color:red'></span>" +
        "</a>" +
        "</td>" +
        "</tr>";

    $("#relatedDocTable").append(tr).show();
    $($(element).closest('ul')).html("");
    $('#searchRelatedDoc').val("");
    toastr.success('Əlaqəli sənəd əlavə olundu');
}

function AddAnswerDocToDataTable(element) {
    var div = $(element).find("div");
    var dubCount = 0;

    $.each($("#answerDocTable tr"),
        function () {
            var docId = $(this).attr('data-DocId');
            console.log(docId);

            if (div[1].innerText == docId) {
                dubCount++;
            }
        });

    if (dubCount != 0) {
        toastr.warning('Bu sənəd artıq əlavə olunub');
        $(element.closest('ul')).html("");
        $('#searchAnswerDocument').val("");
        return;
    }

    GetJointExecutors($(element).val());
    $('#searchAnswerDocument').val("");
    AppendRowToAnswerTable(div, element);
}

function AppendRowToAnswerTable(div, element) {
    var count = $('#answerDocTable').find('tr').length;

    var tr = "<tr id='tr' class='data-row rowSelector'" + "data-DocId='" + div[1].innerText + "'>" +
        //"<td style='text-align:center!important;font-weight:bold'>" + count + "</td>" +
        "<td style='display:none'>" + div[1].innerText + "</td>" +
        "<td style='text-align:center!important'>" + "<a href='/az/Document/GetDocView?token=" + div[5].innerText + "' target='_blank'>" + div[2].innerText + "</a>" + "</td>" +
        //"<td style='text-align:center!important'>" + div[2].innerText + "</td>" +
        "<td style='text-align:center!important'>" + div[3].innerText + "</td>" +
        "<td style='text-align:center!important'>" + "" + (div[4].innerText == 2 ? "<select class='selectpicker' onchange='GetSelectValue(this)' id='answerDocSelect" + count + "' data-live-search = 'true' data-width ='100%'>" : "") +
        "</select>" + "</td>" +
        "<td style='text-align:center!important'>" +
        "<button type='button' onclick='deleteRowRelated(" + div[1].innerText + ",this)' id='deleteRowDataTable' class='btn btn-default btn-sm remove'>" +
        "<span class='fas fa-trash-alt icon-size' style='color:red'></span>" +
        "</a>" +
        "</td>" +
        "</tr>";
    $("#answerDocTable").append(tr).show();

    $.get("/az/outgoing/Document/GetResult",
        function (data) {
            var select = $("#answerDocSelect" + count).empty().append($("<option>Seç</option>").val("-1"));
            $.each(data,
                function () {
                    select.append($("<option></option>")
                        .val(this.ResultId)
                        .html(this.ResultName));
                });
            $('.selectpicker').selectpicker('refresh');
            select.next("button").addClass("bs-placeholder");
        });
    $($(element).closest('ul')).html("");
    $('#searchAnswerDocument').val("");
    toastr.success('Cavab sənədi əlavə olundu');
    return;
}

function DeleteAnswerDoc(element) {
    var answerDocId = $(element).closest("tr").attr("data-DocId");
    var relatedType = $(element).attr("data-relatedType");
    var token = $("#spanToken").html();

    var url = `/az/OutGoing/Document/DeleteAnswerDoc?token=${token}`;

    if (relatedType == 1)
        return true;

    return $.ajax({
        url: url,
        type: 'POST',
        async: false,
        data: { answerDocId: answerDocId },
        success: function (result) {
            return result;
        }
    });
}

function deleteRowDataTable(element) {
    Swal.fire({
        title: 'Bu sətir cədvəldən silinəcək',
        type: 'warning',
        showCancelButton: true,
        cancelButtonText: 'Ləğv et',
        confirmButtonText: 'Təsdiqlə'
    }).then((result) => {
        if (result.value) {
            $(element).closest('tr').remove();
            var rowCountAuthor = $('#dataTableOrgAuthor').find('.data-row').length;
            var rowCountRelDoc = $('#relatedDocTable').find('.data-row').length;
            if (rowCountAuthor === 0) {
                $('#dataTableOrgAuthor').hide();
                $("#labelForAddNewAuthorModal").css("display") === "block"
                    ? $("#labelForAddNewAuthorModal").hide()
                    : "";
                $('#searchAuthor').closest('div').find('.es-list').empty();
                $('#searchAuthor').val("");
            }

            if (rowCountRelDoc === 0) {
                $('#relatedDocTable').hide();
            }
            $('#searchAuthor').closest('div').find('.es-list').empty();
            $('#searchAuthor').val("");
            $('#searchRelatedDoc').val("");
            $('#searchRelatedDoc').closest('div').find('.es-list').empty();

            Swal.fire({
                type: 'success',
                title: 'Məlumat silindi',
                showConfirmButton: false,
                timer: 1000
            });
        }
    });
}

function CommonFunction(element) {
    element.mousedown();
}

function GetSelectValue(element) {
    $(element).closest("tr").attr("data-ResultId", $(element).val());
}
function addWhomAddressed(element) {
    var whomAddressValue = $("#WhomAddress").val();
    var whomAddress = $("#WhomAddress").find('option:selected').text();
    //var dubCount = 0;
    //var executionStatus = $("#ExecutionStatus").find('option:selected').text();
    //$.each($("#tbWhomAddress tr"),
    //    function () {

    //        var workPlaceId = $("#tbWhomAddress ").find('.data-row').attr('data-whomaddress');
    //        console.log(workPlaceId);
    //        if (whomAddressValue == workPlaceId) {
    //            dubCount++;
    //        }
    //    });
    //if (dubCount != 0) {
    //    toastr.warning('Bu sənəd artıq əlavə olunub');

    //    return;
    //}
    if (whomAddressValue != '') {
        var whomCount = $('#tbWhomAddress').find('.data-row').length;
        var markup = "<tr class='data-row rowSelector'" +
            "data-WhomAddress='" +
            whomAddressValue +
            "'>" +
            '<td>' +
            whomAddress +
            '</td>' +
            //'<td>' +
            //executionStatus +
            //'</td>' +
            '<td style="width:20px">' +
            "<a href='javascript:void(0);' onclick='deleteRowDataTable(this)' id='deleteRowDataTable' class='remove'><span class='fas fa-trash-alt btn' style='color:red'></span></a>" +
            '</td>' +
            '</tr>';
        $("#tbWhomAddress").append(markup);
        toastr.success('Məlumat əlavə olundu');
        $("#WhomAddress").val('');
        //$("#ExecutionStatus").val('');
        $('.selectpicker').selectpicker('refresh');
    } else {
        toastr.warning('Zəhmət olmasa məcburi xanaları doldurun');
    }

}




function AddAuthorToDataTable(element) {
    $("#addAuthorModal").modal();
    var divElements = $(element).find("div");
    var rowCount = $('#dataTableOrgAuthor').find('.data-row').length;
    $('input[name="hiddenorgid"]').val(divElements[1].innerText);
    $('label[name="hidden1"]').text(divElements[2].innerText);
    $($(element).closest('ul')).empty();
    $("#searchAuthor").val("");
    //  toastr.success('Məlumat əlavə olundu');
}

function AddAuthorToDataTableSEC(element) {
    //$("#addNewAuthorModal").modal();
    var divElements = $(element).find("div");
    var rowCount = $('#dataTableOrgAuthor').find('.data-row').length;

    console.log(divElements[1].innerText, divElements[2].innerText);

    var tr = '<tr id="tr" class="data-row rowSelector" ' +
        ' data-AuthorId="' + divElements[1].innerText + '"' +
        ' data-AuthorOrganizationId="' + divElements[2].innerText + '"' +
        ' data-OrganizationName="' + divElements[3].innerText + '"' +
        ' data-FullName="' + divElements[4].innerText + '"' +
        ' data-AuthorDepartmentName="' + (divElements[5].innerText === "---" ? null : divElements[5].innerText) + '"' +
        ' data-PositionName="' + (divElements[6].innerText === "---" ? null : divElements[6].innerText) + '">' +
        '</tr>';

    var td = '<td scope="col" style="text-align:center!important;font-weight:bold">' + (++rowCount) + '</td>' +
        '<td style="display:none">' + divElements[1].innerText + '</td>' +
        '<td style="display:none">' + divElements[2].innerText + '</td>' +
        '<td style="text-align:center!important">' + divElements[3].innerText + '</td>' +
        '<td>' + divElements[4].innerText + '</td>' +
        '<td style="text-align:center!important">' + divElements[5].innerText + '</td>' +
        '<td style="text-align:center!important">' + divElements[6].innerText + '</td>' +
        '<td>' +
        '<a href="javascript:void(0);" onclick="deleteRowDataTable(this)" id="deleteRowDataTable" class="remove">' +
        '<span class="fas fa-trash-alt btn" style="color:red"></span>' +
        '</a></td>';
    $("#dataTableOrgAuthor").append($(tr).append(td)).css("display", "block");
    $($(element).closest('ul')).empty();
    $("#searchAuthor").val("");
    toastr.success('Məlumat əlavə olundu');
}

$('#addNewAuthorButton').on('click',
    function () {
        console.log("new");
        var formData = new FormData();

        formData.append("surname", $('input[name="surname"]').val());
        formData.append("firstName", $('input[name="firstName"]').val());
        formData.append("fatherName", $('input[name="fatherName"]').val());
        formData.append("organizationName", $('input[name="organizationName"]').val());
        formData.append("positionName", $('input[name="positionName"]').val());
        formData.append("departmentName", $('input[name="departmentName"]').val());
        formData.append("organizationId", $('input[name="organizationId"]').val());
        formData.append("positionId", $('input[name="positionId"]').val());
        formData.append("departmentId", $('input[name="departmentId"]').val());
        formData.append("addressName", $('input[name="addressName"]').val());
        console.log(formData);
        $.ajax({
            url: '/az/OutGoing/Document/AddNewAuthor',
            data: formData,
            type: 'POST',
            success: function (data) {
                console.log(data);
                if (data != null) {
                    console.log(data);
                    toastr.success("Melumat ugurla yadda saxlanildi");

                    var list = '<li value="' + data[0] + '" class="es-visible" style="display: block;">' +
                        '<div class="row">' +
                        '<div class="col-3" hidden>' + data[0] + '</div>' +
                        '<div class="col-3" hidden>' + data[1] + '</div>' +
                        '<div class="col-3">' + $('input[name="organizationName"]').val() + '</div>' +
                        '<div class="col-3">' + $('input[name="firstName"]').val() + ' ' + $('input[name="surname"]').val() + ' ' + $('input[name="fatherName"]').val() + '</div>' +
                        '<div class="col-3">' + $('input[name="departmentName"]').val() + '</div>' +
                        '<div class="col-3">' + $('input[name="positionName"]').val() + '</div>' +
                        '<div class="col-3">' + $('input[name="addressName"]').val() + '</div>' +
                        '</div>' +
                        '</li>';

                    $("#addNewAuthorModal").modal('hide');// modali bagliyiriq
                    $("#labelForAddNewAuthorModal").css("display") === "block" // add new author buttonun hide edirik
                        ? $("#labelForAddNewAuthorModal").hide()
                        : "";
                    $("#searchAuthor").val(""); //inputu temizliyirik
                    $('.inputSelector').val("");
                    $('.inputSelector').empty();
                    $('.es-list').empty();
                    AddAuthorToDataTableSEC(list);//yeni muellif daxil etmek panelinden
                } else {
                    toastr.warning("Məlumat əlavə olunmadı. Zəhmət olmasa yenidən cəhd edin.");
                }
            },
            processData: false,
            contentType: false
        });

        //if ($('input[name="organizationName"]').val() !== "" &&
        //    $('input[name="positionName"]').val() !== "") { //$('input[name="departmentName"]').val() !== ""

        //} else {
        //    $.each($(".required"), function () {
        //        if ($(this).val() === "") {
        //            $(this).css("border", "1px solid red");
        //        } else {
        //            $(this).css("border", "1px solid #ced4da");
        //        }
        //    });
        //    toastr.warning("Bütün məcburi xanaların doldurulduğuna əmin olun.");
        //}
    });



$('#addExistAuthorButton').on('click',
    function () {
        console.log("EXIST");
        var formData = new FormData();
        //formData.append("hiddenauthorid", $('input[name="hiddenauthorid"]').text());
        //formData.append("hiddenorgid", $('input[name="hiddenorgid"]').val());
        formData.append("surname", $('input[name="surname1"]').val());
        formData.append("firstName", $('input[name="firstName1"]').val());
        formData.append("fatherName", $('input[name="fatherName1"]').val());
        formData.append("organizationName", $('label[name="hidden1"]').text());
        formData.append("positionName", $('input[name="positionName1"]').val());
        formData.append("departmentName", $('input[name="departmentName1"]').val());
        formData.append("organizationId", $('input[name="hiddenorgid"]').val());
        formData.append("positionId", $('input[name="positionId1"]').val());
        //formData.append("departmentId", $('input[name="departmentId1"]').val());
        formData.append("addressName", $('input[name="addressName1"]').val());
        console.log(formData);
        $.ajax({
            url: '/az/OutGoing/Document/AddNewAuthor',
            data: formData,
            type: 'POST',
            success: function (data) {
                console.log(data);
                if (data != null) {
                    console.log(data);
                    toastr.success("Melumat ugurla yadda saxlanildi");

                    var list = '<li value="' + data[0] + '" class="es-visible" style="display: block;">' +
                        '<div class="row">' +
                        '<div class="col-3" hidden>' + data[0] + '</div>' +
                        '<div class="col-3" hidden>' + data[1] + '</div>' +
                        '<div class="col-3">' + $('label[name="hidden1"]').text() + '</div>' +
                        '<div class="col-3">' + $('input[name="firstName1"]').val() + ' ' + $('input[name="surname1"]').val() + ' ' + $('input[name="fatherName1"]').val() + '</div>' +
                        '<div class="col-3">' + ' ' + '</div>' +
                        '<div class="col-3">' + $('input[name="positionName1"]').val() + '</div>' +
                        '<div class="col-3">' + $('input[name="addressName1"]').val() + '</div>' +
                        '</div>' +
                        '</li>';


                    $("#addAuthorModal").modal('hide');// modali bagliyiriq
                    $("#labelForAddNewAuthorModal").css("display") === "block" // add new author buttonun hide edirik
                        ? $("#labelForAddNewAuthorModal").hide()
                        : "";
                    $("#searchAuthor").val(""); //inputu temizliyirik
                    $('.inputSelector').val("");
                    $('.inputSelector').empty();
                    $('.es-list').empty();
                    AddAuthorToDataTableSEC(list);

                } else {
                    toastr.warning("Məlumat əlavə olunmadı. Zəhmət olmasa yenidən cəhd edin.");
                }
            },
            processData: false,
            contentType: false
        });

    });


