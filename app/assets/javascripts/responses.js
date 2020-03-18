$(document).on('turbolinks:load', function() {
  $(document).on('ajax:success', '.quick-poll-form, .survey_response_form', function(e) {
    $(this).replaceWith(e.detail[2].responseText)
  }).on('ajax:error', function(e) {
    $('.survey_response_form, .quick-poll-form').replaceWith('<h1>Something went wrong.Try again later</h1>')
  })

  $(document).on('click', '.survey-radio', function(e) {
    $(this).siblings('.survey-radio').prop('checked', false)
    $(this).prop('checked', true)
  })
})