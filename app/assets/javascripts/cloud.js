var REVIEW_TYPES = {
    initial: 'initial_reviews',
    progress: 'progress_reviews'
}

var SYSTEM_ERROR_TEXT = 'System error, please try again or contact Computer Services';

$(".initial-review, .progress-review").click(function() 
{
    var id = $(this).data('id');
    if (!id) {
        requireAuthorisation();
    }

    $("#open-id").val(id);
    if ($(this).hasClass('initial-review')) {
        return initialReviewRequest(this, id);
    }

    return progressReviewRequest(this, id);
})

$("#edit-review").click(function() 
{
    $("[name='progress_review[body]']").prop("disabled", false);
    /*
    // if Person.user.superuser?
    $("[name='progress_review[working_at]']").prop("disabled", false);
    $("div#current-level").css('display','block');
    $("#progress_review_level").prop("disabled", false);
    */
    $(this).hide();
    $("#save-review").show();
})

$("#save-review").click(function() 
{
    requireAuthorisation();

    var id = getValidOpenId();
    var url = base + REVIEW_TYPES['progress'] + '/' + id;
    var data = {'body': $("[name='progress_review[body]']").val()
                /*
                // if Person.user.superuser?
		, 'working_at': $("[name='progress_review[working_at]']").val()
                , 'level': $("[name='progress_review[level]']").val()
                */
               };

    ajaxRequest(url, 'PUT', data, function(review) {
        $("[name='progress_review[body]']").prop("disabled", true);
        $("[name='progress_review[body]']").val(review.progress_review.pretty_body);
        /*
        // if Person.user.superuser?
        $("[name='progress_review[working_at]']").prop("disabled", true);
        $("[name='progress_review[working_at]']").val(review.progress_review.working_at);
        $('div[data-id="' + id + '"] > h4').text(review.progress_review.working_at);
        $("div#current-level").css('display','none');
        $("#progress_review_level").prop("disabled", true);
        if ( ["purple", "green", "amber", "red"].indexOf(review.progress_review.level) >= 0 ) {
            if ( ! $('div[data-id="' + id + '"]').hasClass(review.progress_review.level) ) {
                $('div[data-id="' + id + '"]').removeClass("purple green amber red");
                $('div[data-id="' + id + '"]').addClass(review.progress_review.level);
                }
        } else {
            $('div[data-id="' + id + '"]').removeClass("purple green amber red");
        }
        */
        $("#save-review").hide();
        $("#edit-review").show();
    })
})

$("#edit-initial-review").click(function() 
{
    $("[name='initial_review[body]']").prop("disabled", false);
    /*
    // if Person.user.superuser?
    $("[name='initial_review[target_grade]']").prop("disabled", false);
    */
    $(this).hide();
    $("#save-initial-review").show();
})

$("#save-initial-review").click(function() 
{
    requireAuthorisation();

    var id = getValidOpenId();
    var url = base + REVIEW_TYPES['initial'] + '/' + id;
    var data = {'body': $("[name='initial_review[body]']").val()
                /*
                // if Person.user.superuser?
                , 'target_grade': $("[name='initial_review[target_grade]']").val()
                */
               };

    ajaxRequest(url, 'PUT', data, function(review) {
        $("[name='initial_review[body]']").prop("disabled", true);
        $("[name='initial_review[body]']").val(review.initial_review.pretty_body);
        /*
        // if Person.user.superuser?
        $("[name='initial_review[target_grade]']").prop("disabled", true);
        $("[name='initial_review[target_grade]']").val(review.initial_review.target_grade);
        $('div[data-id="' + id + '"] > h3').text(review.initial_review.target_grade);
        */
        $("#save-initial-review").hide();
        $("#edit-initial-review").show();
    })
})


function initialReviewRequest(request, id)
{
    reviewRequest('initial', $(request), function(data) {
        if (!id) {
            return displayInitialForm(data.progress);
        }

        displayInitialReview(data.initial_review);
    })
}

function progressReviewRequest(request, id)
{
    var attendance = $(request).data('att');
    var number = $(request).data('number');

    if (!attendance) {
        throw new MissingAttendanceDataException();
    }

    if (!number) {
        throw new MissingReviewNumberException();
    }

    reviewRequest('progress', $(request), function(data) {
        if (!id) {
            return displayProgressForm(data.progress, attendance, number);
        }

        displayProgressReview(data.progress_review);
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
    $("#spinner").modal("show")

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
    })    
}

function displayProgressForm(progress, attendance, reviewNumber)
{
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
}

function displayProgressReview(review)
{
    disableInputs("#new_progress_review");
    $("[name='progress_review[attendance]']").val(review.attendance);
    $("[name='progress_review[working_at]']").val(review.working_at);
    $("[name='progress_review[number]']").val(review.number);
    $("[name='progress_review[body]']").val(review.pretty_body);

    /*
    // if Person.user.superuser?
    if ( ["purple", "green", "amber", "red"].indexOf(review.level) >= 0 ) {
        $("[name='progress_review[level]'] > option").prop("selected",false);
        $("[name='progress_review[level]'] > option." + review.level).prop("selected",true);
    } else {
        $("[name='progress_review[level]'] > option").prop("selected",true);
    }
    */

    $("#review-by").text('\
        By ' + escapeHtml(review.person.name) + ' on ' + escapeHtml(review.pretty_created_at)
    )

    $("#current-level").hide();
    $("#review-submit").hide();

    if (authorisation) {
        $("#save-review").hide();
        $("#edit-review").show();
    }

    $("#submitted").show();
    $("#review-modal").modal("show");
}

function displayInitialForm(progress)
{
    enableInputs("#new_initial_review");
    fillScores(progress)
    $("[name='initial_review[target_grade]']").val("");
    $("[name='initial_review[body]']").val("");
    $("[name='initial_review[progress_id]']").val(progress.id);

    $("#submitted").hide();
    $("#initial-review-submission").show();
    $("#initial-modal").modal("show");
}

function displayInitialReview(review)
{
    disableInputs("#new_initial_review");
    fillScores(review.progress);
    $("[name='initial_review[target_grade]']").val(review.target_grade);
    $("[name='initial_review[body]']").val(review.pretty_body);
    $("#initial-review-by").text('\
        By ' + escapeHtml(review.person.name) + ' on ' + escapeHtml(review.pretty_created_at)
    )

    $("#submitted").show();

    if (authorisation) {
        $("#save-initial-review").hide();
        $("#edit-initial-review").show();        
    }

    $("#initial-review-submission").hide();
    $("#initial-modal").modal("show");
}

function fillScores(scores)
{
    $("[name=maths_ia]").val(scores.bksb_maths_ia);
    $("[name=maths_da]").val(scores.bksb_maths_da);
    $("[name=english_ia]").val(scores.bksb_english_ia);
    $("[name=english_da]").val(scores.bksb_english_da);
    $("[name=qca_score]").val(scores.qca_score);
    $("[name=nat_target]").val(scores.nat_target_grade);

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
    })
}

function disableInputs(form)
{
    $(form).find('select, input, textarea').each(function() {
        $(this).prop("disabled", true);
    })   
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
})
