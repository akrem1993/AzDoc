(function ($) {
    /*jQuery extensionMethods*/
    $.fn.getFormData = function () {
        var arr = $(this).serializeArray();
        var obj = new Object();
        $(arr).each(function (index, item) {
            obj[item.name] = item.value;
            //var intVal = TryParseInt(item.value, null)
            //if (intVal !== null) {
            //    obj[item.name] = intVal;
            //}
            //else {
            //    obj[item.name] = item.value;
            //}
        });

        return obj;
    };

    $.fn.jsonFormData = function () {
        return JSON.stringify($(this).getFormData());
    };

    function TryParseInt(str, defaultValue) {
        var retValue = defaultValue;
        if (str !== null) {
            if (str.length > 0 && !isNaN(str)) {
                retValue = parseInt(str);
            }
        }
        return retValue;
    }

    //datetimepicker
    $.fn.datetimePicker = function () {
        $(this).each(function (index, item) {
            var el = $(item);
            var input = el.find('input');

            var picker = new MaterialDatetimePicker({ weekStart: 1, minDate: new Date() })
                .on('submit', function (value) {
                    $(input).val(value.format('DD.MM.YYYY HH:mm'));
                    $(input).text(value.format('DD.MM.YYYY HH:mm'));

                    if ($(input).val()) {
                        $(el).find('label').addClass("active");
                    }
                    else
                        $(el).find('label').removeClass("active");
                });

            $(el).click('click', function () {
                picker.open();
            }, false);
        });
    }

    $.expr[":"].Contains = jQuery.expr.createPseudo(function (arg) {
        return function (elem) {
            return jQuery(elem).text().toUpperCase().indexOf(arg.toUpperCase()) >= 0;
        };
    });

    function s4() {
        return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
    }

    function mhmGuid() {
        return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
    };

    $.fn.mhmselect = function () {
        /* There's ▲: &#9650; and ▼: &#9660; */
        $(this).each(function (index, item) {
            //mhm-select deyilse
            if (!$(item).hasClass('mhm-select')/* || $(item).is(':disabled')*/) return;

            var link = $(item).data('link');
            if ($(item).is('select')) {
                var uniqueId = mhmGuid();
                var label = $(item).find('option:selected').html() || $(item).find('option:first').html() || "";
                var sanitizedLabelHtml = label.replace(/"/g, '&quot;');
                var container = $('<div class="mhm-select"></div>');
                container.addClass($(item).attr('class'));
                if ($(item).is(':disabled')) container.addClass('disabled');

                $(item).before(container);
                container.append(item);

                container.append('<input type="text" id="input-' + uniqueId + '"class="mhm-select" placeholder="Seçim edin" value="' + sanitizedLabelHtml + '"/><span class="caret"></span>');
                var options = $('<ul class="mhm-select" id="ul-' + uniqueId + '"></ul>');
                container.append(options);

                $(item).children().each(function (index, opt) {
                    options.append('<li class="mhm-option' + ($(opt).is(':selected') ? " active" : "") + '" data-index="' + index + '"><span>' + $(opt).html() + '</span></li>');
                });

                options.find('li.mhm-option').each(function (i, v) {
                    $(v).click(function (e) {
                        if (!$(v).hasClass('disabled') && !$(v).hasClass('optgroup')) {
                            var selected = true;
                            $(item).find('option').eq(i).prop('selected', selected);
                            // Trigger onchange() event
                            $(item).trigger('change');
                        }
                    });
                });

                var txtBox = container.find('input.mhm-select');
                $(txtBox).focus(function () {
                    var div = $(this).closest('div.mhm-select');
                    $(div).addClass('opened');

                    $(div).find('ul.mhm-select > li').removeClass('hide');
                    $(div).find('li.mhm-option-undefined').remove();
                });

                $(txtBox).blur(function () {
                    $(this).closest('div.mhm-select').removeClass('opened');
                    var filter = $(this).val();
                    if (filter !== undefined && filter !== null && filter !== '') {
                        $(this).val(($(item).find('option:selected').html() || '').replace(/&nbsp;/g, ' '));
                    }
                });

                $(container).find('span.caret').click(function () {
                    var selectDiv = $(this).closest('div.mhm-select');
                    if (!$(selectDiv).hasClass('opened'))
                        $(selectDiv).children('input.mhm-select').trigger('focus');
                });

                $(txtBox).bind('keyup change', function (e) {
                    var filter = $(this).val();
                    var selectlist = $(this).closest('div.mhm-select').find('ul.mhm-select');

                    if (filter != undefined && filter.length > 0) {
                        $(selectlist).find("li.mhm-option>span:not(:Contains(" + filter + "))").parents('li').removeClass('active').addClass('hide');
                        $(selectlist).find("li.mhm-option>span:Contains(" + filter + ")").parents('li').removeClass('hide');
                    } else {
                        $(selectlist).find('li').removeClass('hide').removeClass('active');
                    }
                    var first = selectlist.find('li:not(.hide)')[0];
                    if (filter === undefined || filter === null || filter === '' || first === null || first === undefined)
                        $(item).val('');
                    else
                        $(item).children().eq($(first).data("index")).prop("selected", true);
                    $(item).trigger('change');

                    $(selectlist).find('li.mhm-option-undefined').remove();

                    if ($(selectlist).find('li.mhm-option:not(.hide)').length < 1 && (link !== null && link !== undefined && link !== ''))
                        $(selectlist).append('<li class="mhm-option-undefined" data-text="' + filter + '"><span>"' + filter + '" əlavə edin</span></li>');

                    //re
                });

                $(options).on('mousedown', function (event) {
                    event.preventDefault();
                }).on('click', 'li.mhm-option', function () {
                    var input = $(this).closest('div.mhm-select').find('input.mhm-select');
                    $(options).children().removeClass('active').removeClass('hide');
                    $(this).addClass('active');
                    $(input).val(this.textContent).blur();
                }).on('click', 'li.mhm-option-undefined', function () {
                    var input = $(this).closest('div.mhm-select').find('input.mhm-select');

                    if (link === null || link === undefined || link === '') return;

                    $.ajax({
                        type: "POST",
                        url: link,
                        contentType: "application/json; charset=utf-8",
                        dataType: "json",
                        data: JSON.stringify({ 'value': $(input).val() }),
                        success: function (response) {
                            $(item).html('');

                            $.each(response, function (index, value) {
                                $(item).append('<option value="' + value.Id + '"' + ($(input).val() === value.Name ? " selected" : "") + '>' + value.Name + '</option>');
                            });

                            var parent = $(item).parent('div');
                            if (parent !== null && parent !== undefined && parent.hasClass('mhm-select')) {
                                parent.before(item);
                                parent.remove();
                            }

                            $(item).mhmselect();
                            $(item).closest('div.mhm-select').find('input.mhm-select').trigger('focus');
                        }
                    });
                });
            }
        });
    };
})(jQuery);