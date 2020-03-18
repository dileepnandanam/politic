$(document).on('turbolinks:load', function() {
  $(document).on('ajax:success', '.new-option', function(e) {
    $(this).siblings('.new-option-form').html(e.detail[2].responseText)
  })
  
  $(document).on('ajax:success', '.option-form', function(e) {
    $(this).closest('.new-option-form').siblings('.options').append(e.detail[2].responseText)
  })

  $(document).on('ajax:error', '.option-form', function(e) {
    $('this').html(e.detail[2].responseText)
  })

  $(document).on('ajax:success', '.delete-option', function(e) {
    $(this).closest('.option').remove()
  })

  $(document).on('ajax:success', '.answer-type-form', function(e) {
    $(this).closest('.question').replaceWith(e.detail[2].responseText)
  })

  $(document).on('ajax:success', '.edit-option', function(e) {
    $(this).siblings('.option-edit-form-container').html(e.detail[2].responseText)
  })
  $(document).on('ajax:success', '.option-edit-form-container > form', function(e) {
    $(this).closest('.option').replaceWith(e.detail[2].responseText)
  })
  $(document).on('ajax:error', '.option-edit-form-container > form', function(e) {
    $(this).replaceWith(e.detail[2].responseText)
  })

 
})