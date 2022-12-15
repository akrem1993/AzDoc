var SAlert = function () {
    var deleteSuccess = function () {
        Swal.fire({
            type: 'success',
            title: 'Məlumat silindi',
            showConfirmButton: false,
            timer: 1000
        });
    }

    var addSuccess = function () {
        Swal.fire({
            type: 'success',
            title: 'Məlumat əlavə olundu',
            showConfirmButton: false,
            timer: 1000
        });
    }

    var failed = function () {
        Swal.fire({
            type: 'error',
            title: 'Xəta baş verdi',
            showConfirmButton: false,
            timer: 1000
        });
    }

    var success = function (title) {
        Swal.fire({
            type: 'success',
            title: title,
            showConfirmButton: false,
            timer: 1000
        });
    }

    return {
        deleteSuccess: function () {
            return deleteSuccess();
        },
        failed: function () {
            return failed();
        },
        addSuccess: function () {
            return addSuccess();
        },
        success: function (title) {
            return success(title);
        }
    }
}();

$.fn.isEmpty = function () {
    return (this == "");
};

$.fn.isUndefined = function () {
    return (this == undefined);
};

$.fn.isEmptyOrUndefined = function () {
    return (this == "" || this == undefined);
};
