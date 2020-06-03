$(document).on('turbolinks:load', function() {
  $(document).on('ajax:success', '.quick-poll-form, .survey_response_form', function(e) {
    var container = $(this).closest('.question')
    var height = $(container).css('height')
    $(this).replaceWith(e.detail[2].responseText)
    $(container).css('height', height)
    $(container).animate({height: '300px'}, 1000)
    locate_me()
  })

  $(document).on('ajax:error', '.quick-poll-form, .survey_response_form', function(e) {
    $(this).replaceWith(e.detail[2].responseText)
  })

  $(document).on('click', '.survey-radio', function(e) {
    $(this).siblings('.survey-radio').prop('checked', false)
    $(this).prop('checked', true)
  })
})