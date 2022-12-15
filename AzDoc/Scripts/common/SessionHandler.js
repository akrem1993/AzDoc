$(function () {
    setInterval(setTime, 1000);
    sessionIsExpired = false;
    sessionModalIsOpen = false;

    $('#user-profile-img').popover({
        html: true,
        container: "body",
        trigger: "focus",
        placement: 'bottom',
        content: 'Loading...'
    });


    $("#SessionModal").keypress(function (e) {
        if ($("#SessionModal").hasClass("show") && e.which == 13) {
            PingRefreshSession();
        }
    });
});

var sessionIsExpired = false;
var sessionModalIsOpen = false;



function setTime() {
    console.log('setSessionTime');
    var minutes = parseInt($("#span-expire-time").attr("minutes"));
    var seconds = parseInt($("#span-expire-time").attr("seconds"));
    var newMinutes = minutes;
    var newSeconds = seconds;

    //if (sessionIsExpired) return;

    if (minutes === 0 && seconds === 0) {
        SessionExpired();
        return;
    }
    else {
        if (seconds === 0) {
            newSeconds = 59;
            newMinutes = minutes - 1;
        } else {
            newSeconds = seconds - 1;
        }
        var currentTime = padZero(newMinutes) + ":" + padZero(newSeconds);
        $("#span-expire-time-text").text(currentTime);
        $("#span-expire-time").attr("seconds", newSeconds);
        $("#span-expire-time").attr("minutes", newMinutes);
    }

    SessionExpireNotify(newMinutes, newSeconds);
}


function SessionExpired() {
    sessionIsExpired = true;
    console.log('Session is expired======================================');
    $("#span-expire-time").attr("minutes", '0');
    $("#span-expire-time").attr("seconds", '0');
    $("#span-expire-time-text").text('00:00');
    $('#session-status-icon').css('color', '#ca3c3c');
    $('#session-status-icon').removeClass('fa-circle-notch');
    $('#session-status-icon').addClass('fa-circle');
    $('#session-status-text').text('Sessiyanız bitib');
    $('#SessionTimeoutWarningIcon').hide();
    $('#SessionExpiredIcon').show();
    $('#modalSessionİnfo').text('Sessiyanız bitib.Login səhifısinə keçid olsun?');
    ShowSessionModal();
    //$('#refreshSession').hide();
    //var popover = $('#user-profile-img').data('bs.popover');
    //popover.config.content = PopoverExpiredContent();
    $('#user-profile-img').popover('show');

}

function SessionExpireNotify(min, sec) {
    //if (min <= 2) {
	   // $('#SessionTimeoutWarningIcon').show();
	   // $('#SessionTimeoutWarningIcon').attr('title', 'Sessiyanızın bitmə vaxtı: ' + padZero(min) + ':' + padZero(sec));
    //}

    if (min < 1) {
        //var popover = $('#user-profile-img').data('bs.popover');
        //popover.config.content = PopoverContent(min, sec);
        $('#user-profile-img').popover('show');
        $('#modalSessionİnfo').text(SessionConfirmContent(min, sec));
        ShowSessionModal();
        //if (!sessionModalIsOpen) {
        //    ShowSessionModal();
        //    $('#SessionTimeoutWarningIcon').click(ShowSessionModal());
        //    $('#SessionExpiredIcon').click(ShowSessionModal());
        //    $('#session-status-icon').click(ShowSessionModal());
        //    sessionModalIsOpen = true;
        //}
    }
}

function ShowSessionModal() {
	$('#SessionModal').modal("show");
}

$('#SessionModal').on("hidden.bs.modal", function () {
    if (sessionIsExpired) {
	    PingRefreshSession();
	}
});


function SessionConfirmContent(min, sec) {
    return 'Sessiyanızın bitmə vaxtı: ' + padZero(min) + ':' + padZero(sec) + '.Sessiyanız yenilənsin?';
}

function PopoverContent(minutes, seconds) {
    return '<div class="media">' +
        '<i class="fas fa-info-circle" >' +
        '<span> ' +
        'Sessiyanızın bitmə vaxtı: ' + padZero(minutes) + ':' + padZero(seconds) + '' +
        '</span>' +
        '</i>' +
        '</div>';
}

function PingRefreshSession() {

    if (sessionIsExpired) {
        window.location = "/LogOut";
        return;
    }

    $.ajax({
        type: "POST",
        url: "/az/Feedback/PingSession",
        success: function (timeOut) {
            $("#span-expire-time").attr('data-sessiontimeout', timeOut);
            RefreshSession();
        }
    });
}

function RefreshSession() {
    //console.log('Session is refreshed======================================');
    var min = $("#span-expire-time").attr('data-sessiontimeout');
    $('#session-status-icon').css('color', '#75ab41');
    $('#session-status-icon').removeClass('fa-circle');
    $('#session-status-icon').addClass('fa-circle-notch');
    $('#session-status-text').text('Aktiv');
    $("#span-expire-time").attr("minutes", min);
    $("#span-expire-time").attr("seconds", 0);
    $('#user-profile-img').popover("hide");
    $('#SessionTimeoutWarningIcon').hide();
    $('#SessionExpiredIcon').hide();
    $('#SessionModal').modal("hide");
    $('#SessionTimeoutWarningIcon').unbind("click");
    $('#SessionExpiredIcon').unbind("click");
    $('#session-status-icon').unbind("click");
    sessionIsExpired = false;
    sessionModalIsOpen = false;
}

function PopoverExpiredContent() {
    return '<i class="fas fa-exclamation-triangle"><span> Səhifəni yeniləyin</span></i>'
}

function padZero(x) {
    return x < 10 ? ("0" + x) : x;
}