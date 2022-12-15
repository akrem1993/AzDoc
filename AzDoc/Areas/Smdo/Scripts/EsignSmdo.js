var filesarray = [];
var eimza = eimzaLib();

$("#sign").on("click",
    function () {
        //eimza.isSigningServiceWorking().then(onSigningWorking, onSigningDown);

        //imzanin melumatlarini getirir
        $("button#getCerts").click(function () {
            reset();
            $("#progressBarContainer").hide();
            //eimza.readCertificates().then(onSuccessReadCertificates, onError);
        });

        $("#signFile").click(function () {
            reset();
            refreshIntervalId = setInterval(function () {
                if (percent == 100) {
                    toastr.success('Sənəd uğurla imzalandı');
                    clearInterval(refreshIntervalId);
                    setTimeout(EsignSuccess, 1000);
                }

                changeProgressBar(percent, notes[percent]);
                if (percent < 100) percent += 20;

            }, 1000);
        });

    });

var percent = 0;
var refreshIntervalId;
var dtsIntervalId;

var notes = {
    20: 'İmzalama prosesi başlayıb...',
    40: 'İmzalama prosesi başlayıb...',
    60: 'Vaxt möhürü əlavə edilir...',
    80: 'Vaxt möhürü əlavə edilir...',
    100: 'Sənəd uğurla imzalandı...'
};


function onSigningDown() { clearInterval(refreshIntervalId); }

function onError() {
    clearInterval(refreshIntervalId);
}

function onSuccess() { }

function EsignSuccess() {
    $.ajax({
        type: 'POST',
        url: '/az/Smdo/Operation/SignDocument'
    });

    percent = 0;
    reset();
    addSignedRow();
    $('#signatureDialogModal').modal('hide');
    $("#sign").hide();
    $('#sendButton').prop("disabled", false);
}



function addSignedRow() {
    $('#hiddenSignAz').show();

    var row = '<tr><td>2</td><td style="text-align:center"> <img src="/Areas/Smdo/Scripts/azerbaijan.svg" height="25" width="25" /></td><td>Ramin Quluzadə</td><td>Ramin Quluzadə</td><td>E-İmza</td>' +
        '<td><i class="fas fa-fingerprint operationIcons" style="color: #4e9a46"></i>&nbsp;İmzalanıb</td> ' +
        '</tr >';

    $('#tblOperationHistory').append(row);


}

function addDtsRow() {
    var row = '<tr><td>8</td><td style="text-align:center"> <img src="/Areas/Smdo/Scripts/azerbaijan.svg" height="25" width="25" /></td><td>Шульган Константин Константинович</td> <td>Ramin Quluzadə</td><td>Cavab sənədi</td>' +
        '<td onclick="ShowDvcs();"><i class="fas fa-calendar-check operationIcons" style="color: #4e9a46"></i>&nbsp;Təsdiqlənib (DTS)</td>' +
        '</tr>';

    $('#tblOperationHistory').append(row);
}


function ShowDvcs() {
    $.ajax({
        beforeSend: function () {
            window.ShowLoading();
        },
        url: '/az/Smdo/Mail/GetKvitansiya',
        success: function (res) {
            $('#KvitansiyaView').html(res);
            $('#DvcsKvitansiyaModal').modal('show');
        },
        complete: function () {
            window.CloseLoading();
        }
    });
}

function addSendedRow() {
    //$('#tblOperationHistory tr:last').remove();
    var row = '<tr><td>3</td><td style="text-align:center"> <img src="/Areas/Smdo/Scripts/azerbaijan.svg" height="25" width="25" /></td><td>Ramin Quluzadə</td><td>Шульган Константин Константинович</td><td>Göndərmə</td>' +
        '<td><i class="fas fa-paper-plane operationIcons" style="color: #4e9a46"></i>&nbsp;Göndərlib</td>' +
        '</tr>';

    $('#tblOperationHistory').append(row);
}

function onSigningWorking() {
    $("#failinfo").hide();

    $("#signFile").click(function () {
        reset();
        refreshIntervalId = setInterval(function () {
            if (percent == 100) {
                toastr.success('Sənəd uğurla imzalandı');
                clearInterval(refreshIntervalId);
                setTimeout(EsignSuccess, 1000);
            }

            changeProgressBar(percent, notes[percent]);
            if (percent < 100) percent += 20;

        }, 1000);
    });

    $("button#getCerts").click();
}

function DtsProgress() {
    dtsIntervalId = setInterval(function () {
        if (percent == 100) {
            toastr.success('Sənəd uğurla yoxlanıldı və təstiqləndi');
            clearInterval(dtsIntervalId);
            DtsSucces();
        }

        changeProgressBarDts(percent, 'Yoxlanış gedir...');
        if (percent < 100) percent += 20;

    }, 800);
}

function changeProgressBarDts(percentage, status) {
    console.log("changeProgressBar");
    $("#progressBar1").css("width", percentage + "%");
    $("#progressBar1").html(percentage + "%");

    $("#progressStatus1").html(status);
}

function DtsSucces() {
    $.ajax({
        type: 'POST',
        url: '/az/Smdo/Operation/ConfirmDts',
        success: function () {
            $("#confirmDts").hide();
            $('#confirmDtsDialogModal').modal('hide');
            addDtsRow();
        }
    });
}


function reset() {
    console.log("reset");
    $("#progressBarContainer").show();
    $("#failinfo").hide();
}

function changeProgressBar(percentage, status) {
    console.log("changeProgressBar");
    $("#progressBar").css("width", percentage + "%");
    $("#progressBar").html(percentage + "%");

    $("#progressStatus").html(status);
}

function onSuccessReadCertificates(data, status) {
    console.log("onSuccessReadCertificates");
    console.log(data);

    if (data.errorCode !== 0) {
        toastr.warning(data.errorDetails);
        $("#progressBarContainer").hide();
        $("#failedMessage").show();
        $("#failedMessage").html(data.errorDetails);
    }

    if (data.certificates) {
        var options = "";
        for (var i = 0; i < data.certificates.length; i++) {
            options +=
                '<option value="' +
                data.certificates[i].serialNumber +
                '">' +
                data.certificates[i].subject +
                "</option>";
        }
        $("#certificatesDiv").show();
        $("select#ctlCertificates").html(options);
    }
}