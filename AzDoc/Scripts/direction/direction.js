
var fullSource = [];
var leftSource = [];
var rightSource = [];

$(document).ready(function () {

    $(".modal-content button.close").click(function () {
        $("#directionModal").css("display", "none");
        //$(".modal-backdrop").css("z-index", "1040");
        $("#dynamiccontext").find(".modal-backdrop").remove();
    });

    $('.selectpicker').selectpicker('refresh');
});
//DirectionEditPanel
function loadData(urlLeft, urlRight) {
    rightSource = [];

    if (urlRight === '') {
        rightSource = $('#gridDestination').DataList();
    }
    else {
        window.ShowLoading();
        $.ajax({
            url: urlRight,
            type: 'POST',
            success: function (response) {
                rightSource = response.Items;//gelen neticeni emal ucun gotururuk

                $('#gridDestination').UpdateGrid({ items: rightSource, totalCount: 0 });//gridin yeni source ile bind edirik
            },
            error: function (response) {
                //BURDA NESE YAZMAQ LAZİM OLACAQ
            }
        });
    }


    $.ajax({
        url: urlLeft,
        type: 'POST',
        success: function (response) {
            leftSource = [];//left cedvel ucun source nezerde saxlayiriq
            fullSource = response.Items;//gelen neticeni emal ucun gotururuk

            $(fullSource).each(function (index, item) {  // gelen neticeden sag cedvele aid melumatlari exclude edirik
                if (rightSource.In(item, 'ExecutorWorkplaceId') === -1) {
                    leftSource.push(item);
                }
            });

            $('#gridSource').UpdateGrid({ items: leftSource, totalCount: 0 });//gridin yeni source ile bind edirik
            if (response.MyProperty == 1 && directioneditpanel.docReady.data.viewbag == 1) {//ikinci wert xidmeti mektublarda melumat ucun gelen sened hali ucun yoxlanilir
                console.log('test gular');
                $('#forInfo').removeAttr('disabled');
                return;
            }
            //else if (response.MyProperty == 0) { $('#forInfo').attr('disabled', '');}

        },
        error: function (response) {
            //BURDA NESE YAZMAQ LAZİM OLACAQ
        }
    }).done(function () {
        window.CloseLoading();
    });
}
$('#infoButtonDirection').click(function () {
    window.ShowLoading();
    $.ajax({
        type: 'POST',
        data: {
            DocId: directioneditpanel.infoClick.data.DocId
        },
        dataType: 'json',
        contenType: 'json',
        url: directioneditpanel.infoClick.url,
        success: function (data) {
            var where = data.where;
            var docno = data.docno;
            var doctype = data.doctype;
            var note = data.note;
            var control = data.control;
            var controlm = data.controlministry;
            var controlorg = data.controlorg;
            $('#docno').html(docno);
            $('#doctype').html(doctype);
            $('#where').html(where);
            $('#content').html(note);
            $('#control').html((control == 1 ? (where + "," + '<br>') : "") + (controlm == 3 ? controlorg : ""));
        },
        fail: function (result) {
            console.log(response);
        }
    }).done(function () {
        window.CloseLoading();
    });

});

function removeAll() {
    var rightSource = $('#gridDestination').DataList();
    var selected = $('#gridDestination').SelectedList();

    if (selected.length > 0) {
        window.ShowLoading();
    }
    $(selected).each(function (index, item) {
        index = rightSource.In(item, 'ExecutorWorkplaceId');
        if (index !== -1) {
            rightSource.splice(index, 1);
        }
    });
    leftSource = [];

    $(fullSource).each(function (index, item) {  // gelen neticeden sag cedvele aid melumatlari exclude edirik
        if (rightSource.In(item, 'ExecutorWorkplaceId') === -1) {
            leftSource.push(item);
        }
    });

    $('#gridDestination').UpdateGrid({ items: rightSource, totalCount: 0 });
    $('#gridSource').UpdateGrid({ items: leftSource, totalCount: 0 });
    window.CloseLoading();
}
function removeExecutor(e, boundData) {
    window.ShowLoading();
    var rightSource = $('#gridDestination').DataList();//yeniden sag cedveldeki mumkun datalari gotururuk
    rightSource.splice(boundData.uid, 1);//cari setri silirik
    if (boundData.SendStatusId == 1) {
        $('#forInfo').removeAttr('disabled');

    }


    $('#gridDestination').UpdateGrid({ items: rightSource, totalCount: 0 })
    leftSource = [];

    $(fullSource).each(function (index, item) {  // gelen neticeden sag cedvele aid melumatlari exclude edirik
        if (rightSource.In(item, 'ExecutorWorkplaceId') === -1) {
            leftSource.push(item);
        }
    });

    $('#gridSource').UpdateGrid({ items: leftSource, totalCount: 0 });
    window.CloseLoading();
}

function addExecutor(e) {
    window.ShowLoading();
    var rightSource = $('#gridDestination').DataList();
    leftSource = [];
    //icra ucun werti nezere alinsin
    if ($('#gridDestination').SelectedList().length >= 0) {

        $.each($('#gridDestination').SelectedList(), function (index, item) {
            if (leftSource.In(item, 'ExecutorWorkplaceId') >= 0) {
                return;
            }

            item.SendStatusId = $(e).data('value');
            item.ExecutorMain = item.SendStatusId === 1 ? true : false;
            item.SendStatusName = $(e).data('sn');

        });
    }
    $.each($('#gridSource').SelectedList(), function (index, item) {
        if (rightSource.In(item, 'ExecutorWorkplaceId') >= 0) {
            return;
        }
        item.SendStatusId = $(e).data('value');
        item.ExecutorMain = item.SendStatusId === 1 ? true : false;
        item.SendStatusName = $(e).data('sn');
        rightSource.push(item);
    });

    $('#gridDestination').UpdateGrid({ items: rightSource, totalCount: 0 });

    $(fullSource).each(function (index, item) {  // gelen neticeden sag cedvele aid melumatlari exclude edirik
        if (rightSource.In(item, 'ExecutorWorkplaceId') === -1) {
            leftSource.push(item);
        }
    });
    var d = new Date();
    var output = d.getFullYear() + '-' +
        ((d.getMonth() + 1) < 10 ? '0' : '') + (d.getMonth() + 1) + '-' +
        (d.getDate() < 10 ? '0' : '') + d.getDate();

    d.setDate(d.getDate() + 15);
    var executiondate = d.getFullYear() + '-' +
        ((d.getMonth() + 1) < 10 ? '0' : '') + (d.getMonth() + 1) + '-' +
        (d.getDate() < 10 ? '0' : '') + d.getDate();

    var value = 0;
    var destination = $('#gridDestination').DataList();
    var date = $('#DirectionPlanneddate').val();
    for (var i = 0; i < destination.length; i++) {
        var item = destination[i]['SendStatusId'];
        if (item == 1)
            value++;
    }
    // console.log(date, value, directioneditpanel.addExecutor.data.workplaceId, output, executiondate);
    if (value == 1 && date == "" && (directioneditpanel.addExecutor.data.workplaceId == 430 || directioneditpanel.addExecutor.data.workplaceId == 23 || directioneditpanel.addExecutor.data.workplaceId == 431)) {
        console.log("YESS");
        $("#DirectionPlanneddate").attr("min", output);
        $("#DirectionPlanneddate").val(executiondate);

    }
    if (value == 1 && date < output && (directioneditpanel.addExecutor.data.workplaceId == 430 || directioneditpanel.addExecutor.data.workplaceId == 23 || directioneditpanel.addExecutor.data.workplaceId == 431)) {
        console.log("NOO");
        $("#DirectionPlanneddate").attr("min", output);
        $("#DirectionPlanneddate").val(executiondate);


    }

    $('#gridSource').UpdateGrid({ items: leftSource, totalCount: 0 });
    window.CloseLoading();
}
function onRowSelected(e, selectedlist) {
    var array = [1, 5, 0, 15];
    var rightSource = $('#gridDestination').DataList();
    for (var i = 0; i < rightSource.length; i++) {
        var item = rightSource[i]['SendStatusId'];
        if (item == 1) break;
    }
    if (selectedlist.length > 1 || item == 1) {
        $('#forInfo').attr('disabled', '');
        return;
    }
    if (directioneditpanel.onRowSelectedProp.data.directionid == 0 && array.includes(directioneditpanel.onRowSelectedProp.data.dirconfirm) && directioneditpanel.onRowSelectedProp.data.dirconfirm != 1) {
        $('#forInfo').removeAttr('disabled');
    }
}
function onRowSelectDestination(e, selectedlist) {
    var array = [1, 5, 0, 15];
    if ($('#gridDestination').SelectedList().length > 1) {
        $('#forInfo').attr('disabled', '');
        return;
    }
    if (directioneditpanel.onRowSelectedProp.data.directionid == 0 && array.includes(directioneditpanel.onRowSelectedProp.data.dirconfirm) && directioneditpanel.onRowSelectedProp.data.dirconfirm != 1) {
        $('#forInfo').removeAttr('disabled');
    }

}
//DirectionEditPanel





$("#directionModal").draggable({
    handle: ".modal-header2"
});
$("#exampleModalCenter").draggable({
    handle: ".modal-header2"
});
var gridHeight = $("#exampleModalCenter .gridContainer").height();
$("#exampleModalCenter .change-size").click(function () {
    $("#exampleModalCenter").toggleClass("full-size");
    if ($("#exampleModalCenter").hasClass("full-size")) {
        var hgh = $("#exampleModalCenter .modal-content").height() - 130;
        $("#ggridSource").jqxGrid("height", hgh);
    }
    else {
        $("#ggridSource").jqxGrid("height", gridHeight);
    }
});

function createfilterwidget(column, columnElement, widget) {
    widget.jqxDropDownList({
        displayMember: 'text', valueMember: 'value',
        dropDownHeight: 500, dropDownWidth: '210px'
    });
}

//DirectionPanel
function directionEdit() {
    $.ajax({
        method: "POST",
        data: {
            docId: directionEditConfig.directionEdit.data.docId, directionId: directionEditConfig.directionEdit.data.directionId
        },
        contenType: 'json',
        dataType: 'html',
        url: directionEditConfig.directionEdit.url,
        beforeSend: function () {
            window.ShowLoading();
        },
        success: function (response) {
            $('#dynamiccontext').html(response);

        },
        complete: function () {
            window.CloseLoading();
        }
    }
    );
}
function ToJavaScriptDate(value) {
    var pattern = /Date\(([^)]+)\)/;
    var results = pattern.exec(value);
    var dt = new Date(parseFloat(results[1]));
    return (dt.getMonth() + 1) + "/" + dt.getDate() + "/" + dt.getFullYear();
}

function DirectionEditPanelSec(e) {
    $.ajax({
        url: directionEditConfig.directionEditPanelSec.url,
        type: 'POST',
        beforeSend: function () {
            window.ShowLoading();
        },
        data: {
            docId: directionEditConfig.directionEditPanelSec.data.docId,
            directionId: e
        },
        success: function (response) {
            $('#dynamiccontext').html(response);


        },
        complete: function () {
            window.CloseLoading();
        },

    });

}

function ConfirmChanging(e) {
    $.ajax({
        method: "GET",
        data: { id: e },
        contenType: 'json',
        dataType: 'json',
        url: directionEditConfig.confirmChanging.url,
        beforeSend: function () {
            window.ShowLoading();
        },
        success: function (response) {
            $('#changeExConfirm').modal();
            $('#NewExecutor').html(response.newExecutor);
            $('#OldExecutor').html(response.oldExecutor);
            $('#executorNote').html(response.executorNote);
            var nameOfObject = window.location.pathname.substring(window.location.pathname.lastIndexOf('/') + 1);


        },
        complete: function () {
            window.CloseLoading();
        }
    });


}
function ConfirmDateChanging(e) {

    $.ajax({
        method: "GET",
        data: { id: e },
        contenType: 'json',
        dataType: 'json',
        url: directionEditConfig.confirmDateChanging.url,
        beforeSend: function () {
            window.ShowLoading();
        },
        success: function (response) {
            $('#changeDateConfirm').modal();
            $('#OldPlannedDate').html(ToJavaScriptDate(response.oldPlannedDate));
            $('#NewPlannedDate').html(ToJavaScriptDate(response.newPlannedDate));
            $('#ExecutorNote').html(response.executorNote);



        },
        complete: function () {
            window.CloseLoading();
        }
    });


}
function SaveChangingDate(e) {


    var model = $('#changeDateForm').getFormData();
    if (model.CommandType == 2 && isNullOrWhiteSpace(model.ExecutorResolutionNote)) {

        toastr.warning('Zəhmət olmasa qeydinizi daxil edin!');
        return;
    }
    $.ajax({
        method: "POST",
        data: { command: model.CommandType, note: model.ExecutorResolutionNote },
        contenType: 'json',
        dataType: 'html',
        url: directionEditConfig.saveChangingDate.url,
        beforeSend: function () {
            window.ShowLoading();
        },
        success: function (response) {
            if (model.CommandType == 1) {
                toastr.success('Təsdiqləndi!');
                $("#changeDateConfirm").css("display", "none");
                $("#dynamiccontext").find(".modal-backdrop").remove();
                $('#doubleClickModal').modal('hide');
                var nameOfObject = window.location.pathname.substring(window.location.pathname.lastIndexOf('/') + 1);
                if (nameOfObject == 'UnreadDocuments') {
                    var pageIndex = $('#gridDMS').CachedGrid().config.params.pageIndex;
                    $('#gridDMS').bindgrid(pageIndex, undefined);

                }
                if (nameOfObject == 'OrgRequests') {
                    var pageIndex = $('#gridOrgRequests').CachedGrid().config.params.pageIndex;
                    $('#gridOrgRequests').bindgrid(pageIndex, undefined);

                }
                if (nameOfObject == 'CitizenRequests') {
                    var pageIndex = $('#gridCitizenRequests').CachedGrid().config.params.pageIndex;
                    $('#gridCitizenRequests').bindgrid(pageIndex, undefined);

                }
                if (nameOfObject == 'ServiceLetters') {
                    var pageIndex = $('#gridServiceLetters').CachedGrid().config.params.pageIndex;
                    $('#gridServiceLetters').bindgrid(pageIndex, undefined);

                }
            }
            else { toastr.success('İmtina edildi!'); }
            $('#changeDateConfirm').remove();
            $('.modal-backdrop').remove();
            setInterval(function () { window.location.reload(); }, 2000);

        },
        complete: function () {
            window.CloseLoading();
        },
        error: function () {
        }
    }).done(function () {
        window.CloseLoading();
    });


}
function isNullOrWhiteSpace(str) {
    return (!str || str.length === 0 || /^\s*$/.test(str))
}
function SaveChanging(e) {


    var model = $('#changeExecutorForm').getFormData();
    if (model.CommandType == 2 && isNullOrWhiteSpace(model.ExecutorResolutionNote)) {

        toastr.warning('Zəhmət olmasa qeydinizi daxil edin!');
        return;
    }
    $.ajax({
        method: "POST",
        data: { command: model.CommandType, note: model.ExecutorResolutionNote },
        contenType: 'json',
        dataType: 'html',
        url: directionEditConfig.saveChanging.url,
        beforeSend: function () {
            window.ShowLoading();
        },
        success: function (response) {
            if (model.CommandType == 1) {
                toastr.success('Təsdiqləndi!');
                $("#changeExConfirm").css("display", "none");
                $("#dynamiccontext").find(".modal-backdrop").remove();
                $('#doubleClickModal').modal('hide');
                var nameOfObject = window.location.pathname.substring(window.location.pathname.lastIndexOf('/') + 1);
                if (nameOfObject == 'UnreadDocuments') {
                    var pageIndex = $('#gridDMS').CachedGrid().config.params.pageIndex;
                    $('#gridDMS').bindgrid(pageIndex, undefined);

                }
                if (nameOfObject == 'OrgRequests') {
                    var pageIndex = $('#gridOrgRequests').CachedGrid().config.params.pageIndex;
                    $('#gridOrgRequests').bindgrid(pageIndex, undefined);

                }
                if (nameOfObject == 'CitizenRequests') {
                    var pageIndex = $('#gridCitizenRequests').CachedGrid().config.params.pageIndex;
                    $('#gridCitizenRequests').bindgrid(pageIndex, undefined);

                }
                if (nameOfObject == 'ServiceLetters') {
                    var pageIndex = $('#gridServiceLetters').CachedGrid().config.params.pageIndex;
                    $('#gridServiceLetters').bindgrid(pageIndex, undefined);

                }
            }
            else { toastr.success('İmtina edildi!'); }
            $('#changeExConfirm').remove();
            $('.modal-backdrop').remove();
            setInterval(function () { window.location.reload(); }, 2000);

        },
        complete: function () {
            window.CloseLoading();
        },
        error: function () {
        }
    }).done(function () {
        window.CloseLoading();
    });
}
function DirectionSendAuthor(e, element) {
    $(element).removeAttr('onclick');
    console.log('aaaaaaaaaaa');
    var token = $('input[name="__RequestVerificationToken"]').val();
    $.ajax({
        url: directionEditConfig.directionSendAuthor.url,
        type: 'POST',
        data: {
            __RequestVerificationToken: directionEditConfig.directionSendAuthor.data.token,
            id: e
        },
        beforeSend: function () {

            window.ShowLoading();

        },
        success: function (response) {
            toastr.success('Sənəd göndərildi!');
            $("#directionModal").css("display", "none");
            $("#dynamiccontext").find(".modal-backdrop").remove();
            $('#doubleClickModal').modal('hide');
            var nameOfObject = window.location.pathname.substring(window.location.pathname.lastIndexOf('/') + 1);
            if (nameOfObject == 'UnreadDocuments') {
                var pageIndex = $('#gridDMS').CachedGrid().config.params.pageIndex;
                $('#gridDMS').bindgrid(pageIndex, undefined);

            }
            if (nameOfObject == 'OrgRequests') {
                var pageIndex = $('#gridOrgRequests').CachedGrid().config.params.pageIndex;
                $('#gridOrgRequests').bindgrid(pageIndex, undefined);


            }
            if (nameOfObject == 'CitizenRequests') {
                var pageIndex = $('#gridCitizenRequests').CachedGrid().config.params.pageIndex;
                $('#gridCitizenRequests').bindgrid(pageIndex, undefined);


            }
            if (nameOfObject == 'ServiceLetters') {
                var pageIndex = $('#gridServiceLetters').CachedGrid().config.params.pageIndex;
                $('#gridServiceLetters').bindgrid(pageIndex, undefined);

            }

        },
        complete: function () {
            window.CloseLoading();
        }
    });

}

function DeleteDirection(e, element) {
    $(element).removeAttr('onclick');
    /// var token = $('input[name="__RequestVerificationToken"]').val();
    $.ajax({
        url: directionEditConfig.deleteDirection.url,
        type: 'POST',
        data: { __RequestVerificationToken: directionEditConfig.deleteDirection.data.token, id: e },
        beforeSend: function () {
            window.ShowLoading();
        },
        success: function (response) {
            toastr.success('Dərkənar silindi!');
            $.ajax({
                method: "POST",
                data: { docId: response },
                contenType: 'json',
                dataType: 'html',
                url: directionEditConfig.deleteDirection.urlresult,
                success: function (response) {
                    $('#dynamiccontext').html(response);
                }
            });
        },
        complete: function () {
            window.CloseLoading();
        }
    });
}
function DirectionConfirm(e, element) {
    $(element).removeAttr('onclick');
    //var token = $('input[name="__RequestVerificationToken"]').val();
    $.ajax({
        url: directionEditConfig.directionConfirm.url,
        type: 'POST',
        data: { __RequestVerificationToken: directionEditConfig.directionConfirm.data.token, id: e },
        beforeSend: function () {
            window.ShowLoading();
        },
        success: function () {
            toastr.success('Sənəd təsdiq edildi!').delay(500);
            $("#directionModal").css("display", "none");
            $("#dynamiccontext").find(".modal-backdrop").remove();
            $('#doubleClickModal').modal('hide');
            var nameOfObject = window.location.pathname.substring(window.location.pathname.lastIndexOf('/') + 1);
            if (nameOfObject == 'UnreadDocuments') {
                var pageIndex = $('#gridDMS').CachedGrid().config.params.pageIndex;
                $('#gridDMS').bindgrid(pageIndex, undefined);

            }
            if (nameOfObject == 'OrgRequests') {
                var pageIndex = $('#gridOrgRequests').CachedGrid().config.params.pageIndex;
                $('#gridOrgRequests').bindgrid(pageIndex, undefined);

            }
            if (nameOfObject == 'CitizenRequests') {
                var pageIndex = $('#gridCitizenRequests').CachedGrid().config.params.pageIndex;
                $('#gridCitizenRequests').bindgrid(pageIndex, undefined);

            }
            if (nameOfObject == 'ServiceLetters') {
                var pageIndex = $('#gridServiceLetters').CachedGrid().config.params.pageIndex;
                $('#gridServiceLetters').bindgrid(pageIndex, undefined);

            }
        },
        complete: function () {
            window.CloseLoading();
        }
    });
}
function DirectionUnConfirm(e, element) {
    $(element).removeAttr('onclick');
    // var token = $('input[name="__RequestVerificationToken"]').val();
    $.ajax({
        url: directionEditConfig.directionUnConfirm.url,
        type: 'POST',
        data: { __RequestVerificationToken: directionEditConfig.directionUnConfirm.data.token, id: e },
        beforeSend: function () {
            window.ShowLoading();
        },
        success: function () {
            toastr.success('Imtina edildi!').delay(500);
            $("#directionModal").css("display", "none");
            $("#dynamiccontext").find(".modal-backdrop").remove();
            $('#doubleClickModal').modal('hide');
            var nameOfObject = window.location.pathname.substring(window.location.pathname.lastIndexOf('/') + 1);
            if (nameOfObject == 'UnreadDocuments') {
                var pageIndex = $('#gridDMS').CachedGrid().config.params.pageIndex;
                $('#gridDMS').bindgrid(pageIndex, undefined);

            }
            if (nameOfObject == 'OrgRequests') {
                var pageIndex = $('#gridOrgRequests').CachedGrid().config.params.pageIndex;
                $('#gridOrgRequests').bindgrid(pageIndex, undefined);

            }
            if (nameOfObject == 'CitizenRequests') {
                var pageIndex = $('#gridCitizenRequests').CachedGrid().config.params.pageIndex;
                $('#gridCitizenRequests').bindgrid(pageIndex, undefined);

            }
            if (nameOfObject == 'ServiceLetters') {
                var pageIndex = $('#gridServiceLetters').CachedGrid().config.params.pageIndex;
                $('#gridServiceLetters').bindgrid(pageIndex, undefined);

            }
        },
        complete: function () {
            window.CloseLoading();
        }
    });
}
//DirectionPanel

///ChangeExecutionDate
function saveChangeDate(e) {
    //window.ShowLoading();
    var model = $('#changeDateForm').getFormData();
    var planneddate = $("#PlannedDate").val();
    var note = $("#ShortContent").val();
    if (planneddate == '' && note == '') {
        return toastr.warning("Zəhmət olmasa xanaları doldurun");
    }
    else if (planneddate == '') {
        return toastr.warning("Yeni icra müddətini seçin");
    }
    else if (note == '') {
        return toastr.warning("Zəhmət olmasa qeydi daxil edin");
    }
    $.ajax({
        method: "POST",
        data: { newDate: model.DocPlanneddate, resolutionNote: model.ExecutorResolutionNote },
        contenType: 'json',
        dataType: 'html',
        url: configdate.saveChangeDate.url,
        beforeSend: function () {
            window.ShowLoading();
        },
        success: function (response) {
            toastr.success('İcra müddətinin dəyişdirilməsi üçün göndərildi!').delay(500);
            $('#changeExecutor').remove();
            $('.modal-backdrop').remove();
            var nameOfObject = window.location.pathname.substring(window.location.pathname.lastIndexOf('/') + 1);
            if (nameOfObject == 'UnreadDocuments') {
                var pageIndex = $('#gridDMS').CachedGrid().config.params.pageIndex;
                $('#gridDMS').bindgrid(pageIndex, undefined);

            }
            if (nameOfObject == 'OrgRequests') {
                var pageIndex = $('#gridOrgRequests').CachedGrid().config.params.pageIndex;
                $('#gridOrgRequests').bindgrid(pageIndex, undefined);

            }
            if (nameOfObject == 'CitizenRequests') {
                var pageIndex = $('#gridCitizenRequests').CachedGrid().config.params.pageIndex;
                $('#gridCitizenRequests').bindgrid(pageIndex, undefined);
                $('#sendForInformationModal').modal('hide');
            }
            if (nameOfObject == 'ServiceLetters') {
                var pageIndex = $('#gridServiceLetters').CachedGrid().config.params.pageIndex;
                $('#gridServiceLetters').bindgrid(pageIndex, undefined);

            }
        },
        complete: function () {
            window.CloseLoading();
        },
        error: function () {
        }
    }).done(function () {
        window.CloseLoading();
    });

}
//ChangeExecutors

function saveChange(e) {
    if (!$("#DirectionWorkplaceId").val() && !$("#ShortContent").val()) {
        return toastr.warning("Zəhmət olmasa xanaları doldurun");
    }
    else if (!$("#DirectionWorkplaceId").val()) {
        return toastr.warning("Yeni icraçını seçin");
    }
    else if (!$("#ShortContent").val()) {
        return toastr.warning("Zəhmət olmasa qeydi daxil edin");
    }

    var model = $('#changeExecutorForm').getFormData();
    if (typeof model.JointExecutor == 'undefined') {
        model.JointExecutor = false;
    }

    $.ajax({
        method: "POST",
        data: { newWorkplaceId: model.DirectionWorkplaceId, resolutionNote: model.ExecutorResolutionNote, jointExecutor: model.JointExecutor },
        beforeSend: function () { window.ShowLoading(); },
        contenType: 'json',
        dataType: 'html',
        url: configChangeExecutor.saveChange.url,
        beforeSend: function () {
            window.ShowLoading();
        },
        success: function (response) {
            toastr.success('İcraçının dəyişdirilməsi üçün göndərildi!').delay(500);
            $('#changeExecutor').remove();
            $('.modal-backdrop').remove();
            var nameOfObject = window.location.pathname.substring(window.location.pathname.lastIndexOf('/') + 1);
            if (nameOfObject == 'UnreadDocuments') {
                var pageIndex = $('#gridDMS').CachedGrid().config.params.pageIndex;
                $('#gridDMS').bindgrid(pageIndex, undefined);

            }
            if (nameOfObject == 'OrgRequests') {
                var pageIndex = $('#gridOrgRequests').CachedGrid().config.params.pageIndex;
                $('#gridOrgRequests').bindgrid(pageIndex, undefined);

            }
            if (nameOfObject == 'CitizenRequests') {
                var pageIndex = $('#gridCitizenRequests').CachedGrid().config.params.pageIndex;
                $('#gridCitizenRequests').bindgrid(pageIndex, undefined);

            }
            if (nameOfObject == 'ServiceLetters') {
                var pageIndex = $('#gridServiceLetters').CachedGrid().config.params.pageIndex;
                $('#gridServiceLetters').bindgrid(pageIndex, undefined);

            }
            // $('#dynamiccontext').html(response);
        },
        complete: function () {
            window.CloseLoading();
        },
        error: function () {
            $('#changeExecutor').remove();
            $("#dynamiccontext").find(".modal-backdrop").remove();
            setInterval(function () { window.location.reload(); }, 2000);
        }
    });
}