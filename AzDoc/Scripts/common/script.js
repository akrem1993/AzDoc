$(document).ready(function () {


    if ($(".leftMenu").length) {
        if (!localStorage.getItem("menuOpened")) {
            localStorage.setItem("menuOpened", "closed");
        }
        else {
            if (localStorage.getItem("menuOpened") === "opened") {
                $("body").addClass("openMenu");
            }
            else if (localStorage.getItem("menuOpened") === "closed") {
                $("body").removeClass("openMenu");
            }
        }
    }


    /*--------------- LAYOUT ------------------*/
    $(".leftMenu .menu li a").click(function () {
        if (!$(this).hasClass("active")) {
            $(this).parents("ul").find(".active").removeClass("active");
            $(this).parents("li").addClass("active");
        }
    });
    $(".leftMenu .menu .drop>a").click(function () {
        var current = $(this);
        $(current).parents(".drop").toggleClass("open");
        $(current).next(".down").slideToggle('500');
        $(".leftMenu .menu li a").click(function () {
            if (!$(this).parents(".drop").length) {
                $(current).parents(".drop").removeClass("open");
                $(current).next(".down").slideUp('fast');
            }
        });
    });
    $(".leftMenu").hover(function () {
        $(this).find(".open .down").slideDown("fast");
    }, function () {
        if (!$("body").hasClass("openMenu"))
            $(this).find(".open .down").slideUp("fast");
    });
    $(".leftMenu .fa-thumbtack").click(function () {
        if ($("body").hasClass("openMenu")) {
            $("body").removeClass("openMenu");
            localStorage.setItem("menuOpened", "closed");
        }
        else {
            $("body").addClass("openMenu");
            localStorage.setItem("menuOpened", "opened");
        }
    });

    $(".leftMenu .hasNotificationPopup a").click(function () {
        if ($(".notificationPopup").hasClass('ntfOpen')) {
            $(".notificationPopup").removeClass('ntfOpen');
        }
        else {
            $("body").addClass("openMenu");
            localStorage.setItem("menuOpened", "opened");
            $(".notificationPopup").addClass('ntfOpen');
        }
    });
    $(".notificationPopup .ntfHeader i.fa-times").click(function () {
        $(".notificationPopup").removeClass('ntfOpen');
    });
    $(document).click(function (e) {
        if (!$(e.target).closest(".notificationPopup").length && !$(e.target).closest(".leftMenu .hasNotificationPopup a").length) {
            $(".notificationPopup").removeClass('ntfOpen');
        }
    });

    // $("footer .profile>a").click(function () {
    //     $("footer .profile").toggleClass("open");
    //     $(document).click(function (e) {
    //         if (!$(e.target).closest("footer .profile a").length) {
    //             $("footer .profile").removeClass("open");
    //         }
    //     });
    // })

    // $("footer").click(function () {
    //     // $(this).find(".dropUp").fadeToggle('fast');
    //     current = $(this);
    //     $(this).toggleClass("opened");
    //     $(this).find(".userAbout").toggle('fast');

    //     $(document).click(function (e) {
    //         if (!$(e.target).closest('footer').length) {
    //             $(current).removeClass("opened");
    //             $(current).find(".userAbout").show('fast');
    //         }
    //     });
    // })
    // $("footer .item").hover(function(){
    //     $(this).find(".about").slideDown('fast');
    // },function(){
    //     $(this).find(".about").slideUp('fast');
    // })

    /*---------------------begin Setting---------------------------*/
    $("#userProfile .prfRight a").click(function (e) {
        e.preventDefault();
        $(this).parents(".prfRight").find(".active").removeClass("active");
        $(this).addClass("active");
        var currNum = $(this).data("nmb");
        $("#userProfile .prfLeft .leftContent").addClass("d-none");
        $("#userProfile .prfLeft .leftContent-" + currNum + "").removeClass("d-none");
    });
    $("#userProfile .prfLeft .userProfileContent a").click(function (e) {
        e.preventDefault();
        $(this).next().click();
    });
    $("#userProfile #profilePhoto").on('change', function (event) {
        var tmppath = URL.createObjectURL(event.target.files[0]);
        $(this).prev().prev().attr('src', tmppath);
    });
    /*---------------------end Setting---------------------------*/

    $(".breadcrumbRow .breadcrumb2 a").tooltip();

    $("table thead .hasFilter .filterInput a").click(function () {
        var filterParent = $(this).parents(".hasFilter");
        if (!$(filterParent).hasClass("filterOpen")) {
            $(filterParent).addClass("filterOpen");
            $(filterParent).append("<div class='filterCol'><ul><li><a href='#'>Başlayan</a></li><li><a href='#'>Tərkibində olan</a></li><li><a href='#'>Tərkibində olmayan</a></li><li><a href='#'>Bitən</a></li><li><a href='#'>Bərabərdir</a></li><li><a href='#'>Bərabər deyil</a></li></ul></div>");
            var current = $(filterParent);
            $(filterParent).find(".filterCol").slideDown('fast');
            $(document).click(function (e) {
                if (!$(e.target).closest(current).length) {
                    $(current).find(".filterCol").slideUp('fast');
                    $(current).find(".filterCol").remove();
                    $(current).removeClass("filterOpen");
                }
            });
        }
        else {
            $(filterParent).find(".filterCol").slideUp('fast');
            $(filterParent).find(".filterCol").remove();
            $(filterParent).removeClass("filterOpen");
        }
    });
    $("table thead .firstHeadRow th").hover(function () {
        if (!$(this).hasClass("mainFreeze") && !$(this).hasClass("empty")) {
            $(this).append("<div class='sortFilter'><ul><li><a href='#'><i class='fas fa-sort-amount-up'></i></a></li><li><a href='#'><i class='fas fa-sort-amount-down'></i></a></li><li><a href='#'><i class='fas fa-ban'></i></a></li></ul></div>");
            $(this).find(".sortFilter").addClass("sortFilterOpen");
        }
    }, function () {
        $(this).find(".sortFilter").remove();
    });

    var freeze = $("table thead .firstHeadRow th.freezeCol").length;
    var emptySize = freeze * 150 + 100;
    $("table th.empty").css("width", emptySize + "px");

    $("table tbody .fa-bars").click(function () {
        var current = $(this);
        if (!$(this).parents("th").hasClass("openAddition")) {
            if (!$(this).parents("tr").hasClass("newRow")) {
                $(this).parents("th").append("<div class='rowAddition infoRow'><div class='info alert-success'><i class='fas fa-info-circle'></i><span>İcraatdadır</span></div></div>");
            }
            else {
                $(this).parents("th").append("<div class='rowAddition'><ul><li><a href='#'>Göndər</a></li><li><a href='edit.html'>Redaktə et</a></li></ul></div>")
            }
            $(this).parents("th").addClass("openAddition");
            $(this).parents("th").find(".rowAddition").slideDown('fast');

            $(document).click(function (e) {
                if (!$(e.target).closest(current).length && !$(e.target).closest(".rowAddition").length) {

                    $(current).parents("th").removeClass("openAddition");
                    $(current).parents("th").find(".rowAddition").slideUp('fast');
                    $(current).parents("th").find(".rowAddition").remove();
                }
            });
        }
        else {
            $(this).parents("th").removeClass("openAddition");
            $(this).parents("th").find(".rowAddition").slideUp('fast');
            $(this).parents("th").find(".rowAddition").remove();
        }

    });
    /*------------------------------------------------*/

    /*-----------------------EDIT-------------------------*/
    $(" .connectDoc .input-group-text").click(function () {
        $(this).parents(".input-group").prev().click();
    });
    $(" .breadCrumbRow a").click(function () {
        $(this).parents(".breadCrumbRow").find("a.brActive").removeClass("brActive");
        $(this).addClass("brActive");
        var brnum = $(this).data('brcrumb');
        $(" .mainContent .contentItem").addClass("d-none");
        $(" .mainContent .contentItem[data-brnum='" + brnum + "']").removeClass("d-none");
    });
    $(" .contentItem a.mBtn-pr").click(function () {
        var currNo = $(this).parents(".contentItem").data('brnum');
        currNo++;
        if ($(" .mainContent .contentItem[data-brnum='" + currNo + "']").length) {
            $(this).parents(".contentItem").addClass('d-none');
            $(" .mainContent .contentItem[data-brnum='" + currNo + "']").removeClass("d-none");
            $(" .breadCrumbRow a[data-brcrumb='" + (currNo - 1) + "']").removeClass("brActive");
            $(" .breadCrumbRow a[data-brcrumb='" + (currNo) + "']").addClass("brActive");

        }
    });
    $(" .contentItem a.mBtn-sec").click(function () {
        var currNo = $(this).parents(".contentItem").data('brnum');
        currNo--;
        if ($(" .mainContent .contentItem[data-brnum='" + currNo + "']").length) {
            $(this).parents(".contentItem").addClass('d-none');
            $(" .mainContent .contentItem[data-brnum='" + currNo + "']").removeClass("d-none");
            $(" .breadCrumbRow a[data-brcrumb='" + (currNo + 1) + "']").removeClass("brActive");
            $(" .breadCrumbRow a[data-brcrumb='" + (currNo) + "']").addClass("brActive");

        }
    });
    $(" .connectDoc #addDocInput").on('change', function () {
        var files = $(this).prop('files');
        var names = $.map(files, function (val) { return val.name; });
        $(this).next().find('input').val(names)
    });

    $(" table tr i.fa-trash").click(function (e) {
        e.preventDefault();
        Swal.fire({
            title: 'Bu sətir cədvəldən silinəcək',
            type: 'warning',
            showCancelButton: true,
            cancelButtonText: 'Ləğv et',
            confirmButtonText: 'Təsdiqlə'
        }).then((result) => {
            if (result.value) {
                $(this).parents("tr").remove();
                Swal.fire(
                    'Əməliyyat həyata keçirildi',
                    '',
                    'success'
                );
            }
        });
    });
    $(".modal-header3 .individual").click(function () {
        $(".modal-body .jurForm").addClass("d-none");
        $(".modal-body .reportsForm").addClass("d-none");

        $(".modal-header3 .juridical").removeClass("active");
        $(".modal-header3 .reports").removeClass("active");

        $(".modal-body .indForm").removeClass("d-none");
        $(this).addClass("active");
    });

    $(" .modal-header3 .juridical").click(function () {
        $(" .modal-body .indForm").addClass("d-none");
        $(".modal-body .reportsForm").addClass("d-none");

        $(" .modal-header3 .individual").removeClass("active");
        $(".modal-header3 .reports").removeClass("active");

        $(" .modal-body .jurForm").removeClass("d-none");
        $(this).addClass("active");
    });

    $(" .modal-header3 .reports").click(function () {
        $(" .modal-body .indForm").addClass("d-none");
        $(".modal-body .jurForm").addClass("d-none");

        $(" .modal-header3 .individual").removeClass("active");
        $(".modal-header3 .juridical").removeClass("active");

        $(" .modal-body .reportsForm").removeClass("d-none");
        $(this).addClass("active");
    });
    /*------------------------------------------------*/

    $('#loader').fadeOut('slow');
    $(".mModal .modal-content").draggable();
});



function readAs(docId) {
    $(`[title='${docId}']`).closest('[role="row"]').removeClass('unread');
}


function unblockInputs() {
    $(document).off('focusin.modal');
}

