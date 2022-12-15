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
                            $(this).addClass("border-danger");
                        }

                        count++;
                    } else {
                        if ($(this).hasClass("selectpicker")) {
                            if ($(this).val() == -1) {
                                $(this).closest("div")
                                    .css("border", "1px solid red")
                                    .css("border-radius", ".25rem");
                            } else {
                                $(this).closest("div")
                                    .css("border", "1px solid transparent");
                            }
                        } else {
                            $(this).removeClass("border-danger");
                        }
                    }
                });

            if (count > 0) {
                toastr.warning("Bütün məcburi xanaların doldurulduğuna əmin olun.");
                return;
            }

            var docEnterDate = $("#DocEnterDate").val();
            var typeOfApplication = $("#TypeOfApplication").val();
            var topicTypeName = $("#TopicTypeName").val();
            var subtitle = $("#Subtitle").val();
            var receivedForm = $("#ReceivedForm").val();
            var typeOfDocument = $("#TypeOfDocument").val();
            var shortContent = $("#ShortContent").val();

            if (docEnterDate != '' && typeOfApplication != '' && topicTypeName != '' && subtitle != -1 && typeOfDocument != '' && receivedForm != '' && shortContent != '') {
                var numberOfApplicants = $('#NumberOfApplicants').val();
                if (numberOfApplicants == 2) {
                    Swal.fire({
                        title: "Müraciətçilərin sayı " + numberOfApplicants + " nəfər olmağına əminsiniz? ",
                        type: 'warning',
                        showCancelButton: true,
                        cancelButtonText: 'Ləğv et',
                        confirmButtonText: 'Təsdiqlə'
                    }).then((result) => {
                        if (result.value) {

                            $('div.breadCrumbRow div:eq(1)').removeClass('disabled');
                            $('div.breadCrumbRow div a[href="#step2"]').trigger('click');
                        }
                    });
                }
                else {
                    $('div.breadCrumbRow div:eq(1)').removeClass('disabled');

                    $('div.breadCrumbRow div a[href="#step2"]').trigger('click');
                }


            }

        });

    // DEMO ONLY //

    $('#prev-step-2').on('click',
        function (e) {
            $('div.breadCrumbRow div:eq(0)').removeClass('disabled');
            $('div.breadCrumbRow div a[href="#step1"]').trigger('click');
        });


});