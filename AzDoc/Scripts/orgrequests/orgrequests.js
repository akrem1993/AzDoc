var index = 1;
var plannedDate = $("#PlannedDate").val();

if (plannedDate != '') {
    $("#PlannedDate").attr("disabled", false);
}
document.getElementById('ExecutionStatus').addEventListener('change', function () {
    if (this.value == 2 || this.value == 3) {
        $("#PlannedDate").attr("disabled", false);
        $("#DocIsAppealBoard").attr("disabled", false);
    }
    else if (this.value == 5) {
        $("#PlannedDate").attr("disabled", true);
        $("#PlannedDate").val('');
        $("#DocIsAppealBoard").attr("disabled", true);
    } else {
        $("#PlannedDate").attr("disabled", true);
        $("#PlannedDate").val('');
        $("#DocIsAppealBoard").attr("disabled", false);
    }
});

$('#TypeOfDocument').on('change', function () {
    if (this.value == 12) {
        $('#tasks').removeClass('display-none');
        $('#basicInformation').removeClass('col-6');
        $('#attachmentDocuments').removeClass(' col-6');
        $('#tasks').addClass('display-block col-4');
        $('#basicInformation').addClass('col-4');
        $('#attachmentDocuments').addClass('col-4');
    } else {
        $('#tasks').addClass('display-none');
        $('#tasks').removeClass('display-block');
        $('#basicInformation').removeClass('col-4');
        $('#attachmentDocuments').removeClass(' col-4');
        $('#basicInformation').addClass('col-6');
        $('#attachmentDocuments').addClass('col-6');
    }
});

$(document).ready(function () {
    $('#tasks').addClass('display-none');
    $('#tasks').removeClass('display-block');
    $('#basicInformation').removeClass('col-4');
    $('#attachmentDocuments').removeClass(' col-4');
    $('#basicInformation').addClass('col-6');
    $('#attachmentDocuments').addClass('col-6');

    //$(".add-row-task").click(function () {
    //    var taskNo = $("#TaskNo").val();
    //    var task = $("#Task").val();
    //    var typeOfAssignment = $("#TypeOfAssignment").find('option:selected').text();
    //    var typeOfAssignmentValue = $("#TypeOfAssignment").val();
    //    var whomAddressed = $("#WhomAddressId").find('option:selected').text();
    //    var whomAddressedValue = $("#WhomAddressId").val();
    //    $("#tb").css("border", "1px solid #ccc");
    //    var rowCount = $("#tb td").closest("tr").length;
    //    rowCount++;
    //    var markup;

    //    if (taskNo != '' && task != '' && typeOfAssignmentValue != '' && whomAddressedValue != '') {
    //        markup = "<tr class='data-row rowSelector'" +
    //            "data-TypeOfAssignment='" + typeOfAssignmentValue + "' " +
    //            "data-TaskNo='" + taskNo + "' " +
    //            "data-Task='" + task + "' " +
    //            "data-WhomAddressId='" + whomAddressedValue + "'> " +
    //            "<td>" +
    //            typeOfAssignment +
    //            "</td>" +
    //            "<td class='typeOfAssignmentValue' style='display:none'>" +
    //            typeOfAssignmentValue +
    //            "</td>" +
    //            "<td>" +
    //            taskNo +
    //            "</td>" +
    //            "<td>" +
    //            task +
    //            "</td>" +
    //            "<td>" +
    //            whomAddressed +
    //            "</td>" +
    //            "<td><a href='javascript:void(0);' onclick='deleteRowDataTable(this)' id='deleteRowDataTable' class='remove'><span class='fas fa-trash-alt btn' style='color:red'></span></a></td></tr>";
    //        $("#tb").append(markup);
    //        $('#TypeOfAssignment').attr("value");
    //        if (typeOfAssignmentValue == 1) {
    //            var options = $('#TypeOfAssignment').find("option");
    //            $.each(options,
    //                function () {
    //                    $(this).val() == 1 ? $(this).attr("disabled", "disabled") : "";
    //                });
    //        }

    //        $("#TaskNo").val(0);
    //        $("#TypeOfAssignment").val('');
    //        $("#WhomAddressId").val('');
    //        $('.selectpicker').selectpicker('refresh');

    //        Swal.fire({
    //            type: 'success',
    //            title: 'Tapşırıq əlavə olundu',
    //            showConfirmButton: false,
    //            timer: 1000
    //        });
    //    }
    //});
});

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

            $('#tb tr').each(function () {
                var typeOfAssignmentValue = $(element).closest("tr").find("td")[2].innerText;
                if (typeOfAssignmentValue == 1) {
                    var options = $('#TypeOfAssignment').find("option");
                    $.each(options,
                        function () {
                            $(this).val() == 1 ? $(this).removeAttr("disabled", "disabled") : "";
                        });
                }
            });

            var rowCountAuthor = $('#dataTableOrgAuthor').find('.data-row').length;
            var rowCountRelDoc = $('#relatedDocTable').find('.data-row').length;
            if (rowCountAuthor === 0) {
                $('#dataTableOrgAuthor').hide();
                $('#hiddenSupervisionCheckbox').hide();
                $("#labelForAddNewAuthorModal").css("display") === "block"
                    ? $("#labelForAddNewAuthorModal").hide()
                    : "";
                $("#supervision").prop("checked", false);
                $('#searchAuthor').closest('div').find('.es-list').empty();
                $('#searchAuthor').val("");
            }

            if (rowCountRelDoc === 0) {
                $('#relatedDocTable').hide();
            }
            $('#hiddenSupervisionCheckbox').hide();
            $('#searchAuthor').closest('div').find('.es-list').empty();
            $('#searchAuthor').val("");
            $('#searchRelatedDoc').val("");
            $('#searchRelatedDoc').closest('div').find('.es-list').empty();
            $("#supervision").prop("checked", false);

            Swal.fire({
                type: 'success',
                title: 'Məlumat silindi',
                showConfirmButton: false,
                timer: 1000
            });
        }
    });
}

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

$('.custom').editableSelect();

$('.custom').on("keypress",
    function (event) {
        if (event.which == 13) {
            var value = $(this).val(); // daxil etdiyimiz data
            if (value.length < 3) {
                return toastr.warning("Axtarış üçün ən azı 3 simvol daxil edin");
            }
            window.ShowLoading();
            $("#searchAuthor").val() === "" ? $("#labelForAddNewAuthorModal").hide() : "";
            var ul = $(this.parentElement).find(".es-list");
            var nextInput = $(this).next(); // hansi melumati cekmek istediyimizi qeyd edirik
            $.ajax({
                url: '/az/Document/GetAuthorInfo',
                type: 'POST',
                data: { data: value, next: nextInput.val() },
                success: function (data) {
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
                    if (nextInput.val() === "4") { // kimden daxil olub
                        if (value === "") {
                            $('#labelForAddNewAuthorModal').hide();
                        } else {
                            if ($('#labelForAddNewAuthorModal').css("display") === "block") { $("#labelForAddNewAuthorModal").hide() };
                            ul.append('<li style="background-color:#267cad;font-style:bold;display:block;color:white" disabled>' +
                                '<div class="row" style="text-align:center">' +
                                '<div class="col-3">Təşkilat</div>' +
                                '<div class="col-3">Ad</div>' +
                                '<div class="col-3">Şöbə</div>' +
                                '<div class="col-3">Vəzifə</div>' +
                                '</div>' +
                                '</li>');

                            $.each(data,
                                function () {
                                    ul.append('<li value="' + this.AuthorId + '" onmousedown="AddAuthorToDataTable(this)" class="es-visible" style="display: block;">' +
                                        '<div class="row">' +
                                        '<div class="col-3" hidden>' + this.AuthorId + '</div>' +
                                        '<div class="col-3" hidden>' + this.AuthorOrganizationId + '</div>' +
                                        '<div class="col-3">' + (this.OrganizationName == null ? "---" : this.OrganizationName) + '</div>' +
                                        '<div class="col-3">' + (this.FullName == null ? "---" : this.FullName) + '</div>' +
                                        '<div class="col-3">' + (this.AuthorDepartmentName == null ? "---" : this.AuthorDepartmentName) + '</div>' +
                                        '<div class="col-3">' + (this.PositionName == null ? "---" : this.PositionName) + '</div>' +
                                        '</div>' +
                                        '</li>'
                                    );
                                });
                        }
                    } else if (nextInput.val() === "5" && value !== "") { // elaqeli sened
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
                    toastr.error("Xəta baş verdi.");
                    console.log('jqXhr: ' + jqXhr + '; textStatus: ' + textStatus + '; errorThrown: ' + errorThrown);
                }
            });
        }
    });

function SetOptionsId(element) {
    $(element.parentElement.parentElement)
        .find('.inputSelector')
        .val($(element).val());
}

function AddAuthorToDataTable(element) {
    var divElements = $(element).find("div");
    var rowCount = $('#dataTableOrgAuthor').find('.data-row').length;

    if (++rowCount > 1) {
        toastr.warning("1 məlumatdan çox məlumat daxil edə bilməzsiz.");
        $(element.closest("ul")).empty();
        $("#searchAuthor").val("");
        return;
    }

    var authorId = divElements[1].innerText;
    var orgId = divElements[2].innerText;
    var orgName = divElements[3].innerText;
    var fullName = divElements[4].innerText;
    var departName = divElements[5].innerText;
    var positionName = divElements[6].innerText;

    if ($.inArray(orgId, controlOrg) !== -1) {

        $("#hiddenSupervisionCheckbox").css("display") === "none" ? $("#hiddenSupervisionCheckbox").show() : $("#hiddenSupervisionCheckbox").hide();
        $('#dataTableOrgAuthor').find(".data-row").css("color", "red");
    }

    var tr = '<tr id="tr" class="data-row rowSelector" ' +
        ' data-AuthorId="' + authorId + '"' +
        ' data-AuthorOrganizationId="' + orgId + '"' +
        ' data-OrganizationName="' + orgName + '"' +
        ' data-FullName="' + fullName + '"' +
        ' data-AuthorDepartmentName="' + (departName === "---" ? null : departName) + '"' +
        ' data-PositionName="' + (positionName === "---" ? null : positionName) + '">' +
        '</tr>';

    var td = '<td scope="col" style="text-align:center!important;font-weight: bold;">' + rowCount + '</td>' +
        '<td style="display:none">' + authorId + '</td>' +
        '<td style="display:none">' + orgId + '</td>' +
        '<td style="text-align:center!important">' + orgName + '</td>' +
        '<td>' + fullName + '</td>' +
        '<td style="text-align:center!important">' + departName + '</td>' +
        '<td style="text-align:center!important">' + positionName + '</td>' +
        '<td>' +
        '<a href="javascript:void(0);" onclick="deleteRowDataTable(this)" id="deleteRowDataTable" class="remove">' +
        '<span class="fas fa-trash-alt icon-size" style="color:red"></span>' +
        '</a></td>';

    $("#dataTableOrgAuthor").append($(tr).append(td)).css("display", "block");
    $("#searchAuthor").css("border", "1px solid #ced4da");
    $($(element).closest('ul')).empty();
    $("#searchAuthor").val("");
    toastr.success('Məlumat əlavə olundu');
}

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

    var tr = "<tr id='tr' class='data-row rowSelector' data-DocId='" + div[1].innerText + "'>" +
        //"<td style='text-align:center!important;font-weight: bold;'>" + (++count) + "</td>" +
        "<td style='display:none'>" + div[1].innerText + "</td>" +
        "<td style='text-align:center!important'>" + "<a href='/az/Document/GetDocView?token=" + div[4].innerText + "' target='_blank'>" + div[2].innerText + "</a>" + "</td>" +
        "<td style='text-align:center!important'>" + div[3].innerText + "</td>" +
        "<td style='text-align:center!important'>" +
        "<a onclick='deleteRowDataTable(this)' id='deleteRowDataTable' class='remove'>" +
        "<span class='fas fa-trash-alt icon-size' style='color:red'></span>" +
        "</a>" +
        "</td>" +
        "</tr>";

    $("#relatedDocTable").append(tr).show();
    $(element.closest('ul')).html("");
    $('#searchRelatedDoc').val("");
    toastr.success('Əlaqəli sənəd əlavə olundu');
}

$('#addNewAuthorButton').on('click',
    function () {
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

        var required = $(".required");
        var count = 0;
        $.each(required,
            function () {
                if (!$(this).val()) {
                    $(this).addClass("border-danger");
                    count++;
                } else {
                    $(this).removeClass("border-danger");
                }
            });

        if (count > 0) {
            toastr.warning("Bütün məcburi xanaların doldurulduğuna əmin olun.");
            return;
        }

        $.ajax({
            url: '/az/OrgRequests/Document/AddNewAuthor',
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
                    AddAuthorToDataTable(list);
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

function CommonFunction(element) {
    element.mousedown();
}

$("#supervision").on("change",
    function () {
        if ($("#supervision").prop("checked") == true) {
            $("#dataTableOrgAuthor").find(".data-row").css("color", "red").css("font-weight", "bold");
        } else {
            $("#dataTableOrgAuthor").find(".data-row").css("color", "").css("font-weight", "");
        }
    });