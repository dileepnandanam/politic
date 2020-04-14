$(document).on('turbolinks:load', function() {
  $(document).on('ajax:success', '.quick-poll-form, .survey_response_form', function(e) {
    $(this).replaceWith(e.detail[2].responseText)
  })

  $(document).on('ajax:error', '.quick-poll-form, .survey_response_form', function(e) {
    $(this).replaceWith(e.detail[2].responseText)
  })

  $(document).on('click', '.survey-radio', function(e) {
    $(this).siblings('.survey-radio').prop('checked', false)
    $(this).prop('checked', true)
  })
})