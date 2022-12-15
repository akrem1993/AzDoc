$(document).ready(function () {

    $('#next-step-2').on('click',
        function (e) {
            var reqCount = 0;
            var rows = $("#tbWhomAddress").find(".data-row");
            if (rows.length > 0) {
                $.each(rows,
                    function () {
                        if ($(this).attr("data-executionstatus") == 1) {
                            $("#PlannedDate").attr("data-required", "");
                            reqCount++;
                        } else {
                            if (reqCount == 0) {
                                $("#PlannedDate").css("border", "1px solid #ced4da");
                                $("#PlannedDate").removeAttr("data-required");
                            }
                        }
                    });
            } else {
                if (!$("#PlannedDate").attr("data-required")) {
                    $("#PlannedDate").css("border", "1px solid #ced4da");
                    $("#PlannedDate").removeAttr("data-required");
                };
            }

            var required = $("[data-required]");
            reqCount = 0;
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

                        reqCount++;
                    } else {
                        if ($(this).hasClass("selectpicker")) {
                            $(this).closest("div")
                                .css("border", "1px solid transparent");
                        } else {
                            $(this).css("border", "1px solid #ced4da");
                        }
                    }
                });

            if (reqCount > 0) {
                toastr.warning("Bütün məcburi xanaların doldurulduğuna əmin olun.");
                return;
            }

            if ($("#WhomAddress").val().length !== 0 || $("#ExecutionStatus").val()) {
                $("#addWhomAddress").css("border", "1px solid red");
                toastr.warning("Bütün məcburi xanaların doldurulduğuna əmin olun.");
                return;
            } else {
                $("#addWhomAddress").css("border", "0");
            }

            $('div.breadCrumbRow div:eq(1)').removeClass('disabled');
            $('div.breadCrumbRow div a[href="#step2"]').click();

        });

    $('#next-step-3').on('click',
        function (e) {
            $('div.breadCrumbRow div:eq(2)').removeClass('disabled');
            $('div.breadCrumbRow div a[href="#step3"]').click();
        });

    // DEMO ONLY //

    $('#prev-step-1').on('click',
        function (e) {
            $('div.breadCrumbRow div:eq(0)').removeClass('disabled');
            $('div.breadCrumbRow div a[href="#step1"]').click();
        });

    $('#prev-step-2').on('click',
        function (e) {
            $('div.breadCrumbRow div:eq(0)').removeClass('disabled');
            $('div.breadCrumbRow div a[href="#step1"]').click();
        });
});