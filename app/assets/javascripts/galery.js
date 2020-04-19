$(document).on('turbolinks:load', function() {
  $(document).on('ajax:success', '.new-galery', function(e) {
    $(this).closest('.post').find('.galery-form-container').html(e.detail[2].responseText)
    $('.cancel').click(function(e) {
      e.preventDefault()
      $(this).closest('form').remove()
    })
  })

  $(document).on('ajax:success', '.galery-form', function(e) {
    $(document).off('ajax:success', '.galery-form')
    %(this).remove()
    $('.galeries-container').prepend(e.detail[2].responseText)
    prepare_asinc_reload()    
  })

  $(document).on('ajax:success', '.edit-galery-form', function(e) {
    $(this).closest('.galery').replaceWith(e.detail[2].responseText)
    prepare_asinc_reload()
  })

  $(document).on('ajax:success', '.edit-galery', function(e) {
    $(this).siblings('.edit-container').html(e.detail[2].responseText)
  })

  $(document).on('ajax:success', '.delete-galery', function(e) {
    $(this).closest('.galery').remove()
  })

  $(document).on('ajax:success', '.add-picture', function(e) {
    $(document).off('ajax:success', '.add-picture')
    $(this).closest('.galery').find('.pictures').append(e.detail[2].responseText)
    prepare_asinc_reload()
  })

  $(document).on('ajax:success', '.remove-picture', function(e) {
    $(this).closest('.picture').remove()
  })
})