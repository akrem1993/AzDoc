$(document).ready(function () {
    

    $('#next-step-2').on('click', function (e) {
        var required = $("[data-required]");
        var count = 0;
        $.each(required,
            function () {
                if ($(this).val() === "") {
                    if ($(this).hasClass("selectpicker")) {
                        $(this).closest("div")
                            .css("border", "1px solid red")
                            .css("border-radius", ".25rem"); 
                    } else {
                        $(this).css("border", "1px solid red");
                    }

                    count++;
                } else {
                    if ($(this).hasClass("selectpicker")) {
                        $(this).closest("div")
                            .css("border", "1px solid transparent");
                    } else {
                        $(this).css("border", "1px solid #ced4da");
                    }
                }
            });


        if (count > 0) {
            toastr.warning("Bütün məcburi xanaların doldurulduğuna əmin olun.");
            return;
        }

        var typeOfDocument = $("#TypeOfDocument").val();
        var signatoryPerson = $("#SignatoryPerson").val();
        var shortContent = $("#ShortContent").val();

        if ((typeOfDocument != '' && signatoryPerson != '' && shortContent != '')) {
            $('div.breadCrumbRow div:eq(1)').removeClass('disabled');

            $('div.breadCrumbRow div a[href="#step2"]').trigger('click');
        }
    });

    // DEMO ONLY //

    var task;
    var tableCount;
    $('#next-step-3').on('click',
        function (e) {
            task = $("#Task").val();
            tableCount = $("#taskTable tr").length;

            if (tableCount == 0) {
               // $("#tb").closest("div.card").css("border", "red solid 1px");
                return toastr.warning("Tapşırıq əlavə edin");
            }

            if (tableCount > 1) {
                $('div.breadCrumbRow div:eq(2)').removeClass('disabled');
                $('div.breadCrumbRow div a[href="#step3"]').trigger('click');
                //$("#tb").closest("div.card").css("border", "#ccc solid 1px");
                $("#Task").val('');
                $("#Task").css("border", "1px solid #ccc");
                //$("#tb").css("border", "1px solid #ccc");
            }
        });

    $('#prev-step-1').on('click',
        function (e) {
            $('div.breadCrumbRow div:eq(0)').removeClass('disabled');
            $('div.breadCrumbRow div a[href="#step1"]').trigger('click');
        });

    $('#prev-step-2').on('click',
        function (e) {
            $('div.breadCrumbRow div:eq(1)').removeClass('disabled');
            $('div.breadCrumbRow div a[href="#step2"]').trigger('click');
        });
});