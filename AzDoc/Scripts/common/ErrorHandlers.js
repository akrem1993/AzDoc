$(document).ajaxError(function (e, xhr, settings, exception) {
    if (xhr != null) {
        e.stopPropagation();
        window.CloseLoading();

        if (xhr.status === 503) {
            SessionExpired();
            xhr.responseText = 'Server muvəqqəti olaraq işləmir';
        }

        if (xhr.status === 401) {
            SessionExpired();
        }

        console.log('Status:' + xhr.status + ',Message:' + xhr.responseText);

        if (xhr.status === 401) {
            toastr.warning(xhr.responseText);
            return;
        }
        
        
        toastr.error(xhr.responseText);
    }
});

$(document).ajaxSuccess(function (e, xhr, settings, exception) {
    if (xhr != null) {
        RefreshSession();
    }
});

$.ajaxSetup({
    cache: false
});