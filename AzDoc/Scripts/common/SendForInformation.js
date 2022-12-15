function deleteRowSendForInformation(element) {
    //$('#deleteSendForInformation').modal('show');

    //$('#deleteSend').click(function () {
    //    $(element).closest('tr').remove();
    //});

    Swal.fire({
        title: 'Bu sətir cədvəldən silinəcək',
        type: 'warning',
        showCancelButton: true,
        cancelButtonText: 'Ləğv et',
        confirmButtonText: 'Təsdiqlə'
    }).then((result) => {
        if (result.value) {
            $(element).closest('tr').remove();

            Swal.fire({
                type: 'success',
                title: 'Məlumat silindi',
                showConfirmButton: false,
                timer: 1000
            });
        }
    });
}

function deleteSenForInformation(personId, element, token) {
    Swal.fire({
        title: 'Bu sətir cədvəldən silinəcək',
        type: 'warning',
        showCancelButton: true,
        cancelButtonText: 'Ləğv et',
        confirmButtonText: 'Təsdiqlə'
    }).then((result) => {
        if (result.value) {
            $.ajax({
                url: `/az/Document/SendForInformationDelete?token=${token}`,
                type: 'POST',
                data: { workPlaceId: personId },
                success: function (result) {
                    if (result) {
                        $(element).closest("tr").remove();
                    }
                }
            });

            Swal.fire({
                type: 'success',
                title: 'Məlumat silindi',
                showConfirmButton: false,
                timer: 1000
            });
        }
    });

    //$('#deleteSendForInformation').modal('show');
    //$('#deleteSend').click(function () {
    //    $.ajax({
    //        url: '/az/Document/SendForInformationDelete',
    //        type: 'POST',
    //        data: { workPlaceId: personId },
    //        success: function (result) {
    //            if (result) {
    //                $(element).closest("tr").remove();
    //            }
    //        }
    //    });
    //});
}


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
