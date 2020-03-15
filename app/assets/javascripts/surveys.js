$(document).on('turbolinks:load', function() {
  $(document).on('ajax:success', '.new-option', function(e) {
    $('.new-option-form').html(e.detail[2].responseText)
  })
  
  $(document).on('ajax:success', '.option-form', function(e) {
    $(this).closest('.new-option-form').siblings('.options').append(e.detail[2].responseText)
  })

  $(document).on('ajax:error', '.option-form', function(e) {
    $('.new-option-form').html(e.detail[2].responseText)
  })

  $(document).on('ajax:success', '.delete-option', function(e) {
    $(this).closest('.option').remove()
  })
})