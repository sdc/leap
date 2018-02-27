var REVIEW_TYPES = {
    initial: 'initial_reviews',
    progress: 'progress_reviews'
}

var SYSTEM_ERROR_TEXT = 'System error, please try again or contact Computer Services';

function person_can_edit_grade()
{
    if ( typeof can_edit_grade !== 'undefined' )
        return ( can_edit_grade == 'true' ) ;
    else
        return false;
}

$(".initial-review, .progress-review").click(function() 
{
    var id = $(this).data('id');
    if (!id) {
        requireAuthorisation();
    }
    var editable = $(this).data('editable');
    if (!editable) {
        editable = false;
    }

    $("#open-id").val(id);
    if ($(this).hasClass('initial-review')) {
        return initialReviewRequest(this, id, editable);
    }

    return progressReviewRequest(this, id, editable);
})

$("#edit-review").click(function() 
{
    $("[name='progress_review[body]']").prop("disabled", false);

    if ( person_can_edit_grade() )
        {
        $("[name='progress_review[working_at]']").prop("disabled", false);
        }
    $("div#current-level").css('display','block');
    $("#progress_review_level").prop("disabled", false);

    $(this).hide();
    $("#save-review").show();
})

$("#save-review").click(function() 
{
    requireAuthorisation();

    var id = getValidOpenId();
    var url = base + REVIEW_TYPES['progress'] + '/' + id;
    var data = $.extend({}, {
                'body': $("[name='progress_review[body]']").val()
                , 'working_at': ( person_can_edit_grade() ) ? $("[name='progress_review[working_at]']").val() : undefined
                , 'level': $("[name='progress_review[level]']").val()
               });

    ajaxRequest(url, 'PUT', data, function(review) {
        $("[name='progress_review[body]']").prop("disabled", true);
        $("[name='progress_review[body]']").val(review.pretty_body);

        if ( person_can_edit_grade() )
            {
            $("[name='progress_review[working_at]']").prop("disabled", true);
            $("[name='progress_review[working_at]']").val(review.working_at);
            $('div[data-id="' + id + '"] > h4').text(review.working_at);
            }
        $("div#current-level").css('display','none');
        $("#progress_review_level").prop("disabled", true);
        if ( ["purple", "green", "amber", "red"].indexOf(review.level) >= 0 ) {
            if ( ! $('div[data-id="' + id + '"]').hasClass(review.level) ) {
                $('div[data-id="' + id + '"]').removeClass("purple green amber red");
                $('div[data-id="' + id + '"]').addClass(review.progress_review.level);
                }
        } else {
            $('div[data-id="' + id + '"]').removeClass("purple green amber red");
        }

        $("#save-review").hide();
        $("#edit-review").show();
    })
})

$("#edit-initial-review").click(function()
{
    $("[name='initial_review[body]']").prop("disabled", false);

    if ( person_can_edit_grade() )
        {
        $("[name='initial_review[target_grade]']").prop("disabled", false);
        }

    $(this).hide();
    $("#save-initial-review").show();
})

$("#save-initial-review").click(function() 
{
    requireAuthorisation();

    var id = getValidOpenId();
    var url = base + REVIEW_TYPES['initial'] + '/' + id;
    var data = $.extend({}, {
                'body': $("[name='initial_review[body]']").val()
                , 'target_grade': ( person_can_edit_grade() ) ? $("[name='initial_review[target_grade]']").val() : undefined
               });

    ajaxRequest(url, 'PUT', data, function(review) {
        $("[name='initial_review[body]']").prop("disabled", true);
        $("[name='initial_review[body]']").val(review.pretty_body);

        if ( person_can_edit_grade() )
            {
            $("[name='initial_review[target_grade]']").prop("disabled", true);
            $("[name='initial_review[target_grade]']").val(review.target_grade);
            $('div[data-id="' + id + '"] > h3').text(review.target_grade);
            }

        $("#save-initial-review").hide();
        $("#edit-initial-review").show();
    })
})


function initialReviewRequest(request, id, editable)
{
    reviewRequest('initial', $(request), function(data) {
        if (!id) {
            return displayInitialForm(data.progress);
        }

        displayInitialReview(data, editable );
    })
}

function progressReviewRequest(request, id, editable)
{
    var attendance = $(request).data('att');
    var number = $(request).data('number');
    var max_number = $(request).data('max-number');

    if (!attendance) {
        throw new MissingAttendanceDataException();
    }

    if (!number) {
        throw new MissingReviewNumberException();
    }

    reviewRequest('progress', $(request), function(data) {
        if (!id) {
            return displayProgressForm(data, attendance, number, max_number);
        }
        displayProgressReview(data, editable );
    })
}

function reviewRequest(type, request, callback)
{
    if (!REVIEW_TYPES.hasOwnProperty(type)) {
        throw new UnknownReviewTypeException('Unknown review type ' + type);
    }

    var id = $(request).data('id');
    var progress_id = $(request).data('progress-id');
    var url = base + REVIEW_TYPES[type] + '/';
    url += !id ? 'new?progress_id=' + progress_id : id;

    ajaxRequest(url, 'GET', null, function(data) {
        callback(data);
    })
}

function ajaxRequest(url, type, data, callback)
{
    $("#spinner").modal("show");

    $.ajax({
        url: url,
        type: type,
        dataType: 'json',
        data: data,

        success: function(json) {
            callback(json);
        },

        error: function(json) {
            $("#spinner").modal("hide")
            notify(SYSTEM_ERROR_TEXT, 'error');
            throw "Communication failure";
        },

        complete: function() {
            $("#spinner").modal("hide")
        },

        timeout: 30000
    });
}

function displayProgressForm(progress, attendance, reviewNumber, maxNumber)
{
    $("#par-guidance").show();
    if ( reviewNumber == 1) {
        $("#par-guidance-previous").hide();
    } else {
        $("#par-guidance-previous").show();
    }
    if ( reviewNumber == maxNumber) {
        $("#par-guidance-next").hide();
    } else {
        $("#par-guidance-next").show();
    }

    enableInputs("#new_progress_review");
    setValueAndReadOnly("[name='progress_review[attendance]']", attendance);
    setValueAndReadOnly("[name='progress_review[number]']", reviewNumber);
    $("[name='progress_review[progress_id]']").val(progress.id);
    $("[name='progress_review[working_at]']").val("");
    $("[name='progress_review[body]']").val("");
    $("[name='progress_review[level]']").val("");

    $("#current-level").show();
    $("#submitted").hide();
    $("#review-submit").show();
    $("#review-modal").modal("show");
    $("#save-review").hide();
    $("#edit-review").hide();
    $("#review_edit_countdown").empty();
}

function displayProgressReview(review, editable)
{
    $("#par-guidance").hide();

    disableInputs("#new_progress_review");
    $("[name='progress_review[attendance]']").val(review.attendance);
    $("[name='progress_review[working_at]']").val(review.working_at);
    $("[name='progress_review[number]']").val(review.number);
    $("[name='progress_review[body]']").val(review.pretty_body);

    if ( ["purple", "green", "amber", "red"].indexOf(review.level) >= 0 ) {
        $("[name='progress_review[level]'] > option").prop("selected",false);
        $("[name='progress_review[level]'] > option." + review.level).prop("selected",true);
    } else {
        $("[name='progress_review[level]'] > option").prop("selected",true);
    }

    $("#review-by").text('\
        By ' + escapeHtml(review.person.name) + ' on ' + escapeHtml(review.pretty_created_at)
    );

    $("#current-level").hide();
    $("#review-submit").hide();

    if (authorisation) {
        $("#save-review").hide();
        $("#edit-review").show();
    }

    $("#submitted").show();
    $("#review-modal").modal("show");
    $("#review_edit_countdown").empty();
    if (authorisation) {
        if( !(editable && review.is_editable) ) {
            $("#save-review").hide();
            $("#edit-review").hide();
        } else {
            $("#save-review").hide();
            $("#edit-review").show();

            if ( !authorisation_a && !authorisation_su )
                {
                startCountdownTimer("#review_edit_countdown", review.countdown_enddate, function() { $("#edit-review").hide(); } );
                $('#review-modal').on('hide.bs.modal', function() { endCountdownTimer(); $("#review_edit_countdown").empty(); } );
                }
        }
    }
}

function displayInitialForm(progress)
{
    enableInputs("#new_initial_review");
    fillScores(progress);
    $("[name='initial_review[target_grade]']").val("");
    $("[name='initial_review[body]']").val("");
    $("[name='initial_review[progress_id]']").val(progress.id);

    $("#submitted").hide();
    $("#initial-review-submission").show();
    $("#initial-modal").modal("show");
    $("#save-initial-review").hide();
    $("#edit-initial-review").hide();
    $("#initial_edit_countdown").empty();
}

function displayInitialReview(review, editable)
{
    disableInputs("#new_initial_review");
    fillScores(review.progress);
    $("[name='initial_review[target_grade]']").val(review.target_grade);
    $("[name='initial_review[body]']").val(review.pretty_body);
    $("#initial-review-by").text('\
        By ' + escapeHtml(review.person.name) + ' on ' + escapeHtml(review.pretty_created_at)
    );

    $("#submitted").show();

    if (authorisation) {
        $("#save-initial-review").hide();
        $("#edit-initial-review").show();
    }

    $("#initial-review-submission").hide();
    $("#initial-modal").modal("show");
    $("#initial_edit_countdown").empty();
    if (authorisation) {
        if( !(editable && review.is_editable) ) {
            $("#save-initial-review").hide();
            $("#edit-initial-review").hide();
        } else {
            $("#save-initial-review").hide();
            $("#edit-initial-review").show();

            if ( !authorisation_a && !authorisation_su )
                {
                startCountdownTimer("#initial_edit_countdown", review.countdown_enddate, function() { $("#edit-initial-review").hide(); } );
//                $('#initial-modal > :button.close').click( function() { endCountdownTimer(); $("#initial_edit_countdown").empty(); } );
                $('#initial-modal').on('hide.bs.modal', function() { endCountdownTimer(); $("#initial_edit_countdown").empty(); } );
                }
        }
    }
}

function fillScores(scores)
{
    $("[name=maths_ia]").val(scores.bksb_maths_ia);
    $("[name=maths_da]").val(scores.bksb_maths_da);
    $("[name=english_ia]").val(scores.bksb_english_ia);
    $("[name=english_da]").val(scores.bksb_english_da);
    $("[name=qca_score]").val(scores.qca_score);
    $("[name=subject_grade]").val(scores.subject_grade);

    disableInputs("#scores");
}

function getValidOpenId()
{
    var id = $("#open-id").val();
    if (!id || !(Math.floor(id) == id && $.isNumeric(id))) {
        throw new MissingReviewNumberException();
    }

    return id;    
}

function requireAuthorisation()
{
    if (!authorisation) {
        throw new AuthorisationFailureException();
    }
}

function setValueAndReadOnly(element, value)
{
    $(element).val(value);
    $(element).prop("readOnly", true);  
}

function enableInputs(element)
{
    $(element).find('select, input, textarea').each(function() {
        $(this).prop("disabled", false);
    });
}

function disableInputs(form)
{
    $(form).find('select, input, textarea').each(function() {
        $(this).prop("disabled", true);
    });
}

function AuthorisationFailureException(message)
{
    this.message = message || 'Authorisation Failure';
    this.name = 'AuthorisationFailureException';
}

function UnknownReviewTypeException(message)
{
    this.message = message || 'Unknown review type';
    this.name = 'UnknownReviewTypeException';
}

function MissingAttendanceDataException(message)
{
    this.message = message || 'Attendance data missing';
    this.name = MissingAttendanceDataException;
}

function MissingReviewNumberException(message)
{
    this.message = message || 'Review number missing';
    this.name = MissingReviewNumberException;
}

// Taken from mustache - not sure this is enough to prevent injection, needs review. 
var entityMap = {
    '&': '&amp;',
    '<': '&lt;',
    '>': '&gt;',
    '"': '&quot;',
    "'": '&#39;',
    '/': '&#x2F;',
    '`': '&#x60;',
    '=': '&#x3D;'
};

function escapeHtml(string) 
{
    return String(string).replace(/[&<>"'`=\/]/g, function fromEntityMap (s) {
        return entityMap[s];
    });
}

$("#new_progress_review").submit(function(a) {
    var b = $(this).find("[required]");
    return $(b).each(function() {
        return null == $(this).val() ? (alert("Required field should not be blank."), $(this).focus(), a.preventDefault(), !1) : void 0
    }), !0
});


var timer_intervals = [];

function startCountdownTimer(timer_div, endtime, fn_expired)
{

    if ( !endtime ) { return; }

    endCountdownTimer();

    var countdown = $(timer_div);
    if ( !countdown ) { return; }

    countdown.data('endtime',endtime);
    var target_date = new Date(endtime).getTime();

    var days, hours, minutes, seconds, ms_step=1000;

    interval =
        setInterval(function () {
        var current_date = new Date().getTime();
        var seconds_left = (target_date - current_date) / 1000;
        if ( seconds_left < 0)
            {
            endCountdownTimer();
            countdown.html('-')
            if ( fn_expired ) { (fn_expired)(); }
            return;
            };
        days = parseInt(seconds_left / 86400);
        seconds_left = seconds_left % 86400;
        hours = parseInt(seconds_left / 3600);
        seconds_left = seconds_left % 3600;
        min = parseInt(seconds_left / 60);
        sec = parseInt(seconds_left % 60);

        countdown.html( 'Edit time remaining:<br>' + days + ' Day' + ( (days == 1) ? ' ' : 's ' ) + hours + 'h ' + min +'m ' + sec + 's' );

        }, ms_step);
    timer_intervals.push(interval);
}

function endCountdownTimer(timer_div)
{
    timer_intervals.forEach(clearInterval);
    timer_intervals = [];
}
