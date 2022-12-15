var index = 1, count = 1;

function addWhomAddressed(element) {
    var whomAddressValue = $("#WhomAddress").val();
    var executionStatusValue = $("#ExecutionStatus").val();
    //var whomAddress = $("#WhomAddress").find('option:selected').text();
    var executionStatus = $("#ExecutionStatus").find('option:selected').text();

    if (whomAddressValue.length == 0 || executionStatusValue == '')
        return toastr.warning('Zəhmət olmasa məcburi xanaları doldurun');

    $.each(whomAddressValue,
        function (index, value) {
            var markup = "<tr class='data-row rowSelector'" +
                "data-WhomAddress='" +
                value +
                "'" +
                "data-ExecutionStatus='" +
                executionStatusValue +
                "'>" +
                '<td style="text-align: left;">' +
                $(`#WhomAddress option[value="${value}"]`).text() +
                '</td>' +
                '<td style="text-align: left;">' +
                executionStatus +
                '</td>' +
                '<td style="width:20px">' +
                "<a href='javascript:void(0);' onclick='DeleteWhomAddressed(-1,this)' id='deleteRowDataTable' class='remove'><span class='fas fa-trash-alt btn btn-light' style='color:red'></span></a>" +
                '</td>' +
                '</tr>';
            $("#tbWhomAddress").append(markup);
        });

    CheckPlannedDate();
    toastr.success('Məlumat əlavə olundu');
    $("#WhomAddress").val('');
    $("#ExecutionStatus").val('');
    $('.selectpicker').selectpicker('refresh');
}

    CheckPlannedDate();

    function DeleteWhomAddressed(taskId, element) {
        Swal.fire({
            title: 'Bu sətir cədvəldən silinəcək',
            type: 'warning',
            showCancelButton: true,
            cancelButtonText: 'Ləğv et',
            confirmButtonText: 'Təsdiqlə'
        }).then((result) => {
            if (result.value) {
                if (taskId === -1) {
                    var count = 0;
                    $(element).closest('tr').remove();
                    CheckPlannedDate();
                    SAlert.deleteSuccess();
                } else {
                    $.post("/az/ServiceLetters/Document/DeleteWhomAddressed", { taskId: taskId },
                        function (data) {
                            if (data === 1) {
                                $(element).closest("tr").remove();
                                CheckPlannedDate();
                                SAlert.deleteSuccess();
                            } else
                                SAlert.failed();
                        });
                }
            }
        });
    }


    function CheckPlannedDate() {
        var count = 0;
        $.each($("#tbWhomAddress").find(".data-row"),
            function () {
                if ($(this).attr("data-executionstatus") == 1) {
                    count++;
                }
            });

        if (count == 0) {
            $("#PlannedDate").val("");
            $("#PlannedDate").attr('disabled', 'disabled');
        }
        else {
            $('#PlannedDate').removeAttr('disabled');
        }
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
                var rowCountRelDoc = $('#relatedDocTable').find('.data-row').length;
                if (rowCountRelDoc === 0) {
                    $('#relatedDocTable').hide();
                }
                $('#searchRelatedDoc').val("");
                $('#searchRelatedDoc').closest('div').find('.es-list').empty();

                SAlert.deleteSuccess();
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
                if ($("#searchAuthor").val() === "")
                    $("#labelForAddNewAuthorModal").hide();

                var ul = $(this.parentElement).find(".es-list");
                var nextInput = $(this).next(); // hansi melumati cekmek istediyimizi qeyd edirik
                $.ajax({
                    url: '/az/Document/GetAuthorInfo',
                    type: 'POST',
                    data: { data: value, next: nextInput.val() },
                    success: function (data) {
                        if (data.length === 0 && value !== "") {
                            var message = "Axtarılan məlumat tapılmadı";
                            ul.empty();
                            $(nextInput).next().val("");
                            toastr.warning(message);
                            return;
                        }

                        ul.empty();
                        if (nextInput.val() === "5" && value !== "") { // elaqeli sened
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
                        } else if (nextInput.val() === "6" && value !== "") { // cavab senedi
                            ul.append('<li style="background-color:#267cad;font-style:bold;display:block;color:white" disabled>' +
                                '<div class="row" style="text-align:center">' +
                                '<div class="col-3">Sənədin nömrəsi</div>' +
                                '<div class="col-3">Sənədin məlumatı</div>' +
                                '</div>' +
                                '</li>');

                            $.each(data,
                                function () {
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

    function AddRelDocToDataTable(element) {
        var div = $(element).find("div");
        var dubCount = 0;
        var count = $('#relatedDocTable').find('.data-row').length;

        $.each($("#relatedDocTable tr"),
            function () {
                var docId = $(this).attr('data-DocId');

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
            //"<td style='text-align:center!important;font-weight:bold'>" + (++count) + "</td>" +
            "<td style='display:none'>" + div[1].innerText + "</td>" +
            "<td style='text-align:center!important'>" + "<a href='/az/Document/GetDocView?token=" + div[4].innerText + "' target='blank'>" + div[2].innerText + "</a>" + "</td>" +
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

    function AddAnswerDocToDataTable(element) {
        var div = $(element).find("div");
        var dubCount = 0;

        $.each($("#answerDocTable tr"),
            function () {
                var docId = $(this).attr('data-DocId');

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
            "<i class='fas fa-trash-alt icon-size' style='color:red'></i>" +
            "</button>" +
            "</td>" +
            "</tr>";

        $("#answerDocTable").append(tr).show();
        $.get("/az/ServiceLetters/Document/GetResult",
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
        $(element.closest('ul')).html("");
        $('#searchAnswerDocument').val("");
        toastr.success('Cavab sənədi əlavə olundu');
        return;
    }


    //$(".dropDownSelector").on("change",
    //    function () {
    //        $(this).closest("tr").attr("data-ResultId", $(this).val());
    //    });

    function GetSelectValue(element) {
        $(element).closest("tr").attr("data-ResultId", $(element).val());
        $(element).closest("tr").attr("data-customValue", $(element).val());

    }

    function CommonFunction(element) {
        element.mousedown();
    }