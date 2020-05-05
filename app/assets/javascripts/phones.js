$(document).on('turbolinks:load', function() {
  $(document).on('ajax:success', '.new-phone', function(e) {
    $(this).closest('.post').find('.phone-form-container').html(e.detail[2].responseText)
  })

  bind_phone_create = function() {
    $(document).on('ajax:success', '.new-phone-form', function(e) {
      $(document).off('ajax:success', '.new-phone-form')
      $(this).closest('.post').find('.phones-container').append(e.detail[2].responseText)
      %(this).remove()
      prepare_asinc_reload()
      bind_picture_add()
      bind_phone_create()
    })
  }
  bind_phone_create()

  $(document).on('ajax:success', '.edit-phone-form', function(e) {
    $(this).closest('.phone').replaceWith(e.detail[2].responseText)
    prepare_asinc_reload()
  })

  $(document).on('ajax:success', '.edit-phone', function(e) {
    $(this).siblings('.edit-phone-container').html(e.detail[2].responseText)
  })

  $(document).on('ajax:success', '.delete-phone', function(e) {
    $(this).closest('.phone').remove()
  })
})