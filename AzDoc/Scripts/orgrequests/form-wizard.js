$(document).ready(function () {

    $('#next-step-2').on('click',
        function (e) {
            var required = $("[data-required]");
            var count = 0;
            $.each(required,
                function () {
                    if (!$(this).val()) {
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

            if ($("#dataTableOrgAuthor").find("tr.data-row").length === 0) {
                $("#searchAuthor").css("border", "1px solid red");
                count++;
            } else {
                $("#searchAuthor").css("border", "1px solid #ced4da");
            }

            if (count > 0) {
                toastr.warning("Bütün məcburi xanaların doldurulduğuna əmin olun.");
                return;
            }

            var topicTypeName = $("#TopicTypeName").val();
            var receivedForm = $("#ReceivedForm").val();
            var docDate = $("#DocDate").val();
            var typeOfDocument = $("#TypeOfDocument").val();

            //if (typeOfDocument == 12) {
            //    $('div.breadCrumbRow div:eq(1)').removeClass('disabled');
            //    $('div.breadCrumbRow div a[href="#step2"]').trigger('click');
            //} else {
            //    $('div.breadCrumbRow div:eq(2)').removeClass('disabled');

            //    $('div.breadCrumbRow div a[href="#step3"]').trigger('click');
            //}
            if (topicTypeName != '' && receivedForm != '' && docDate != '' && typeOfDocument != '') {
                if (typeOfDocument == 12) {
                    $('div.breadCrumbRow div:eq(1)').removeClass('disabled');
                    $('div.breadCrumbRow div a[href="#step2"]').trigger('click');
                } else {
                    $('div.breadCrumbRow div:eq(2)').removeClass('disabled');

                    $('div.breadCrumbRow div a[href="#step3"]').trigger('click');
                }
            }
        });

    $('#next-step-3').on('click',
        function (e) {
            $('div.breadCrumbRow div:eq(2)').removeClass('disabled');
            $('div.breadCrumbRow div a[href="#step3"]').trigger('click');
        });

    // DEMO ONLY //

    $('#prev-step-1').on('click',
        function (e) {
            $('div.breadCrumbRow div:eq(0)').removeClass('disabled');
            $('div.breadCrumbRow div a[href="#step1"]').trigger('click');
        });

    $('#prev-step-2').on('click',
        function (e) {
            var typeOfDocument = $("#TypeOfDocument").val();
            if (typeOfDocument == 12) {
                $('div.breadCrumbRow div:eq(1)').removeClass('disabled');
                $('div.breadCrumbRow div a[href="#step2"]').trigger('click');
            } else {
                $('div.breadCrumbRow div:eq(0)').removeClass('disabled');
                $('div.breadCrumbRow div a[href="#step1"]').trigger('click');
            }
        });
});