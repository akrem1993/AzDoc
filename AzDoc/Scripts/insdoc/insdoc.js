var index = 1;

document.getElementById('TypeOfDocument').addEventListener('change', function () {
    var style = (this.value == 28) ? 'block' : 'none';
    document.getElementById('hidden_SubtypeOfDocument').style.display = style;
});


$(document).ready(function () {
    $(".add-row").click(function () {
        var typeOfDocument = $("#RelatedDocument").find('option:selected').text();

        var markup = "<tr id='tr' >" +
            "<td scope='col'><input type='checkbox' name='record'></td>" +
            "<td scope='col'>" + typeOfDocument + "</td>" +
            "<td scope='col'>" + typeOfDocument + "</td>" +
            "<td scope='col'><a href='javascript:void(0);' onclick='deleteRowDataTable(this)' id='deleteRowDataTable' class='remove'><span class='fas fa-trash-alt btn' style='color:red'></span></a></td></tr>";
        var newHtml = typeOfDocument + typeOfDocument;

        var rowLength = document.getElementById('dataTable').rows.length;

        function fnContains() {
            for (var i = 1; i < rowLength; i++) {
                var html1 = document.getElementById("dataTable").rows[i].cells[1].innerHTML;
                var html2 = document.getElementById("dataTable").rows[i].cells[2].innerHTML;
                var oldHtml = html1 + html2;

                if (newHtml == oldHtml) {
                    return true;
                }
            }
            return false;
        }

        if (fnContains() == false) {
            $("#dataTable").append(markup);
        } else {
            MessageBox("Diqqət", "Təkrar məlumat daxil edirsiniz.Zəhmət olmasa yenidən cəhd edin");
        }
    });

    $(".add-row-task").click(function () {
        var taskNo = $("#TaskNo").val();
        var task = $("#Task").val();
        var typeOfAssignment = $("#TypeOfAssignment").find('option:selected').text();
        var typeOfAssignmentValue = $("#TypeOfAssignment").val();
        var taskCycle = $("#TaskCycle").find('option:selected').text();
        var taskCycleValue = $("#TaskCycle").val();
        var executionPeriod = $("#ExecutionPeriod").val();
        var periodOfPerformance = $("#PeriodOfPerformance").val();
        var originalExecutionDate = $("#OriginalExecutionDate").val();
        var whomAddressed = $("#WhomAddressId").find('option:selected').text();
        var whomAddressedValue = $("#WhomAddressId").val();
        $("#tb").css("border", "1px solid #ccc");

        var markup, newHtml, rowLength, oldHtml, count = 1;


        console.log($("#WhomAddressId").val());
        if ($("#WhomAddressId").val() === "") {
            console.log("asdfgasdf");
            if ($("#WhomAddressId").hasClass("selectpicker")) {
                $("#WhomAddressId").closest("div")
                    .css("border", "1px solid red")
                    .css("border-radius", ".25rem");
            }
        } else {
            if ($("#WhomAddressId").hasClass("selectpicker")) {
                $("#WhomAddressId").closest("div")
                    .css("border", "1px solid transparent");
            }
        }

        if (typeOfAssignmentValue == 1) {
            $("#TypeOfAssignment").css("border", "1px solid #ccc");

            if (taskNo != '0')
                $("#TaskNo").css("border", "1px solid #ccc");
            if (taskNo == '0')
                $("#TaskNo").css("border", "red solid 1px");
            if (task != '')
                $("#Task").css("border", "1px solid #ccc");
            if (task == '')
                $("#Task").css("border", "red solid 1px");
            if (taskCycleValue != '')
                $("#TaskCycle").css("border", "1px solid #ccc");
            if (taskCycleValue == '')
                $("#TaskCycle").css("border", "red solid 1px");
            if (originalExecutionDate != '')
                $("#OriginalExecutionDate").css("border", "1px solid #ccc");
            if (originalExecutionDate == '')
                $("#OriginalExecutionDate").css("border", "red solid 1px");
            if (whomAddressedValue != '')
                $("#WhomAddressId").css("border", "1px solid #ccc");
            if (whomAddressedValue == '')
                $("#WhomAddressId").css("border", "red solid 1px");



            if (taskNo != '' && task != '' && taskCycleValue != '' && originalExecutionDate != '' && whomAddressedValue != '') {
                markup = "<tr class='data-row rowSelector'" +
                    "data-TypeOfAssignment='" + typeOfAssignmentValue + "' " +
                    "data-TaskNo='" + taskNo + "' " +
                    "data-Task='" + task + "' " +
                    "data-TaskCycle='" + taskCycleValue + "'" +
                    "data-ExecutionPeriod='" + executionPeriod + "'" +
                    "data-PeriodOfPerformance='" + periodOfPerformance + "'" +
                    "data-OriginalExecutionDate='" + originalExecutionDate + "'" +
                    "data-WhomAddressId='" + whomAddressedValue + "'> " +
                    "<td>" + typeOfAssignment + "</td>" +
                    "<td>" + taskNo + "</td>" +
                    "<td>" + task + "</td>" +
                    "<td >" + taskCycle + "</td>" +
                    "<td>" + executionPeriod + "</td>" +
                    "<td>" + periodOfPerformance + "</td>" +
                    "<td>" + originalExecutionDate + "</td>" +
                    "<td>" + whomAddressed + "</td>" +
                    "<td style='text-align:center!important'>" +
                    "<a href='javascript:void(0);' onclick='deleteRowDataTable(this)' id='deleteRowDataTable' class='remove btn btn-default'>" +
                    "<span class='fas fa-trash-alt icon-size' style='color:red'></span>" +
                    "</a>" +
                    "</td></tr>";

                //document.getElementById('TypeOfAssignment').selectedIndex = 0;
                //document.getElementById('TaskCycle').selectedIndex = 0;
                //document.getElementById('ExecutionPeriod').value = 1;
                //document.getElementById('PeriodOfPerformance').value = 0;
                //document.getElementById('OriginalExecutionDate').value = 'mm/dd/yyyy';
                //document.getElementById('WhomAddressId').selectedIndex = 0;
                //$('.selectpicker').selectpicker('refresh');

                newHtml = typeOfAssignment + taskNo + task + taskCycle + executionPeriod + periodOfPerformance + originalExecutionDate + whomAddressed;

                rowLength = document.getElementById('tb').rows.length;
                function fnContains2() {
                    for (var i = 1; i < rowLength; i++) {
                        var htmlTypeOfAssignment = document.getElementById("tb").rows[i].cells[1].innerHTML;
                        var htmlTaskNo = document.getElementById("tb").rows[i].cells[2].innerHTML;
                        var htmlTask = document.getElementById("tb").rows[i].cells[3].innerHTML;
                        var htmlTaskCycle = document.getElementById("tb").rows[i].cells[4].innerHTML;
                        var htmlExecutionPeriod = document.getElementById("tb").rows[i].cells[5].innerHTML;
                        var htmlPeriodOfPerformance = document.getElementById("tb").rows[i].cells[6].innerHTML;
                        var htmlOriginalExecutionDate = document.getElementById("tb").rows[i].cells[7].innerHTML;
                        var htmlwhomAddressed = document.getElementById("tb").rows[i].cells[8].innerHTML;
                        var oldHtml = htmlTypeOfAssignment + htmlTaskNo + htmlTask + htmlTaskCycle + htmlExecutionPeriod + htmlPeriodOfPerformance + htmlOriginalExecutionDate + htmlwhomAddressed;
                        console.log(newHtml);
                        console.log(oldHtml);
                        if (newHtml == oldHtml) {
                            return true;
                        }
                    }
                    return false;
                }

                if (fnContains2() == false) {
                    $("#tb").append(markup);
                    ClearTaskInputs();
                } else {
                    MessageBox("Diqqət", "Təkrar məlumat daxil edirsiniz.Zəhmət olmasa yenidən cəhd edin");
                }
            }
        } else {
            if (taskNo != '0')
                $("#TaskNo").css("border", "1px solid #ccc");
            if (taskNo == '0')
                $("#TaskNo").css("border", "red solid 1px");
            if (task != '')
                $("#Task").css("border", "1px solid #ccc");
            if (task == '')
                $("#Task").css("border", "red solid 1px");
            if (typeOfAssignmentValue != '')
                $("#TypeOfAssignment").css("border", "1px solid #ccc");
            if (typeOfAssignmentValue == '')
                $("#TypeOfAssignment").css("border", "red solid 1px");
            if (whomAddressedValue != '')
                $("#WhomAddressId").css("border", "1px solid #ccc");
            if (whomAddressedValue == '')
                $("#WhomAddressId").css("border", "red solid 1px");

            if (task != '' && typeOfAssignmentValue != '' && whomAddressedValue != '') {
                markup = "<tr class='data-row rowSelector' data-TypeOfAssignment='" + typeOfAssignmentValue + "' data-TaskNo='" + taskNo + "' data-Task='" + task + "' data-WhomAddressId='" + whomAddressedValue + "'>" +
                    "<td>" + typeOfAssignment + "</td>" +
                    "<td>" +
                    taskNo +
                    "</td>" +
                    "<td>" + task + "</td>" +
                    "<td></td>" +
                    "<td></td>" +
                    "<td></td>" +
                    "<td></td>" +
                    "<td>" + whomAddressed + "</td>" +
                    "<td style='text-align:center!important'><a href='javascript:void(0);' onclick='deleteRowDataTable(this)' id='deleteRowDataTable' class='remove btn btn-default'><span class='fas fa-trash-alt icon-size' style='color:red'></span></a></td></tr>";

                document.getElementById('TypeOfAssignment').selectedIndex = 0;
                document.getElementById('WhomAddressId').selectedIndex = 0;
                $('.selectpicker').selectpicker('refresh');

                newHtml = typeOfAssignment + taskNo + task + whomAddressed;
                rowLength = document.getElementById('tb').rows.length;

                console.log(newHtml);

                function fnContains() {
                    for (var i = 1; i < rowLength; i++) {
                        var htmlTypeOfAssignment = document.getElementById("tb").rows[i].cells[1].innerHTML;
                        var htmlTaskNo = document.getElementById("tb").rows[i].cells[2].innerHTML;
                        var htmlTask = document.getElementById("tb").rows[i].cells[3].innerHTML;
                        var htmlwhomAddressed = document.getElementById("tb").rows[i].cells[8].innerHTML;
                        oldHtml = htmlTypeOfAssignment + htmlTaskNo + htmlTask + htmlwhomAddressed;
                        console.log(oldHtml);
                        if (newHtml == oldHtml) {
                            return true;
                        }
                    }
                    return false;
                }

                if (fnContains() == false) {
                    $("#tb").append(markup);
                    ClearTaskInputs();
                } else {
                    MessageBox("Diqqət", "Təkrar məlumat daxil edirsiniz.Zəhmət olmasa yenidən cəhd edin");
                }
            }
        }
    });
});


function ClearTaskInputs() {
    document.getElementById('TypeOfAssignment').selectedIndex = 0;
    document.getElementById('TaskCycle').selectedIndex = 0;
    document.getElementById('ExecutionPeriod').value = 0;
    document.getElementById('PeriodOfPerformance').value = 0;
    document.getElementById('OriginalExecutionDate').value = 'mm/dd/yyyy';
    document.getElementById('WhomAddressId').selectedIndex = 0;
    $('#TaskNo').val('');
    $('#Task').val('');
    $('.selectpicker').selectpicker('refresh');
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
            if (rowCountRelDoc === 0) $('#relatedDocTable').hide();

            var taskCount = $('#divTaskTable tr').length;
            if (taskCount == 0) $('#divTaskTable').hide();

            $('#searchRelatedDoc').val("");
            $('#searchRelatedDoc').closest('div').find('.es-list').empty();

            SAlert.deleteSuccess();
        }
    });
}

function deleteRelatedDocRow(element) {
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

function TaskCyclesOnChange() {
    var taskCycle = $("#TaskCycle").val();

    if (taskCycle == 5) {
        document.getElementById("TaskCycle").disabled = false;
        document.getElementById("ExecutionPeriod").disabled = true;
        document.getElementById("PeriodOfPerformance").disabled = true;
        document.getElementById("OriginalExecutionDate").disabled = false;
    }
    else {
        document.getElementById("TaskCycle").disabled = false;
        document.getElementById("ExecutionPeriod").disabled = false;
        document.getElementById("PeriodOfPerformance").disabled = false;
        document.getElementById("OriginalExecutionDate").disabled = false;

        $('#PeriodOfPerformance').val("0");
        if (taskCycle == 2 || taskCycle == 1) {
            $('#PeriodOfPerformance').val("15");
        }

        if (taskCycle == 3 || taskCycle == 4) {
            $('#PeriodOfPerformance').val("30");
        }

    }
}




function disable(element) {
    var typeOfAssignment = $(this).val();
    if (typeOfAssignment == 1) {
        document.getElementById("TaskCycle").disabled = false;
        document.getElementById("ExecutionPeriod").disabled = false;
        document.getElementById("PeriodOfPerformance").disabled = false;
        document.getElementById("OriginalExecutionDate").disabled = false;

        $('#TaskCycle').attr('data_required2');
        $('#ExecutionPeriod').attr('data_required2');
        $('#PeriodOfPerformance').attr('data_required2');
        $('#OriginalExecutionDate').attr('data_required2');
    }
    else {
        document.getElementById("TaskCycle").disabled = true;
        document.getElementById("ExecutionPeriod").disabled = true;
        document.getElementById("PeriodOfPerformance").disabled = true;
        document.getElementById("OriginalExecutionDate").disabled = true;


        document.getElementById('TaskCycle').selectedIndex = 0;
        document.getElementById('ExecutionPeriod').value = 1;
        document.getElementById('PeriodOfPerformance').value = 0;
        document.getElementById('OriginalExecutionDate').value = 'mm/dd/yyyy';

        $("#TaskCycle").css("border", "1px solid #ccc");
        $("#ExecutionPeriod").css("border", "1px solid #ccc");
        $("#PeriodOfPerformance").css("border", "1px solid #ccc");
        $("#OriginalExecutionDate").css("border", "1px solid #ccc");

        $('#TaskCycle').removeAttr('data_required2');
        $('#ExecutionPeriod').removeAttr('data_required2');
        $('#PeriodOfPerformance').removeAttr('data_required2');
        $('#OriginalExecutionDate').removeAttr('data_required2');
    }
}



$(document).ready(function () {
    //$('#ExecutionPeriod').bind("cut copy paste drag drop", function (e) {
    //    e.preventDefault();
    //});

    //$('#PeriodOfPerformance').bind("cut copy paste drag drop", function (e) {
    //    e.preventDefault();
    //});

    var t = false;
    $('#ExecutionPeriod').focus(function () {
        var $this = $(this);

        t = setInterval(
            function () {
                if (($this.val() < 1) && $this.val().length != 0) {
                    if ($this.val() < 1) {
                        $this.val(1);
                    }
                }
            });
    });

    //$('#PeriodOfPerformance').focus(function () {
    //    var $this = $(this);

    //    t = setInterval(
    //        function () {
    //            if (($this.val() < 0 || $this.val() > 22) && $this.val().length != 0) {
    //                if ($this.val() < 0) {
    //                    $this.val(1);
    //                }

    //                if ($this.val() > 22) {
    //                    $this.val(22);
    //                }
    //            }
    //        });
    //});
});
function isNumberKey(evt) {
    var charCode = (evt.which) ? evt.which : evt.keyCode;
    if (charCode > 31 && (charCode < 48 || charCode > 57))
        return false;
    return true;
}

function checkDec(el) {
    var ex = /^[0-9]+\.?[0-9]*$/;
    if (ex.test(el.value) == false) {
        el.value = el.value.substring(0, el.value.length - 1);
    }
}

function bs_input_file() {
    $(".input-file").before(
        function () {
            if (!$(this).prev().hasClass('input-ghost')) {
                var element = $("<input type='file' class='input-ghost' style='visibility:hidden; height:0'>");
                element.attr("name", $(this).attr("name"));
                element.change(function () {
                    element.next(element).find('input').val((element.val()).split('\\').pop());
                });
                $(this).find("button.btn-choose").click(function () {
                    element.click();
                });
                $(this).find("button.btn-reset").click(function () {
                    element.val(null);
                    $(this).parents(".input-file").find('input').val('');
                });
                $(this).find('input').css("cursor", "pointer");
                $(this).find('input').mousedown(function () {
                    $(this).parents('.input-file').prev().click();
                    return false;
                });
                return element;
            }
        }
    );
}
$(function () {
    bs_input_file();
});

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
        "<td style='display:none'>" + div[1].innerText + "</td>" +
        "<td style='text-align:center!important'>" + "<a href='/az/Document/GetDocView?token=" + div[4].innerText + "' target='blank'>" + div[2].innerText + "</a>" + "</td>" +
        "<td style='text-align:center!important'>" + div[3].innerText + "</td>" +
        "<td style='text-align:center!important'>" +
        "<a onclick='deleteRowDataTable(this)' id='deleteRowDataTable' class='btn btn-light remove'>" +
        "<span class='fas fa-trash-alt icon-size' style='color:red'></span>" +
        "</a>" +
        "</td>" +
        "</tr>";

    $("#relatedDocTable").append(tr).show();
    $(element.closest('ul')).html("");
    $('#searchRelatedDoc').val("");
    toastr.success('Əlaqəli sənəd əlavə olundu');
}

function CommonFunction(element) {
    element.mousedown();
}