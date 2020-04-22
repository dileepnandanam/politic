bind_picture_add = function() {
  $('.add-galery-picture').on('click', function(e) {
    $(this).siblings('form').removeClass('d-none')
  })
  $('.picture-submit').on('click', function() {
    $(this).closest('form').addClass('d-none')
  })
}

$(document).on('turbolinks:load', function() {
  bind_picture_add()
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
    $('.galeries-container').append(e.detail[2].responseText)
    prepare_asinc_reload()
    bind_picture_add()   
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
    %(this).remove()
    prepare_asinc_reload()
  })

  $(document).on('ajax:success', '.remove-picture', function(e) {
    $(this).closest('.picture').remove()
  })

  $(document).on('ajax:success', '.post-select-form', function(e) {
    $(this).closest('.picture').replaceWith(e.detail[2].responseText)
    prepare_asinc_reload()
  })

  $(document).on('ajax:success', '.add-galery-picture', function(e) {
    $('.picture-form-container').html(e.detail[2].responseText)
  })
  $(document).on('ajax:success', '.edit-galery-picture', function(e) {
    $(this).siblings('.edit-form-container').html(e.detail[2].responseText)
  })

  $(document).on('ajax:success', '.edit-form-container form', function(e) {
    $(this).closest('.picture').replaceWith(e.detail[2].responseText)
  })
})