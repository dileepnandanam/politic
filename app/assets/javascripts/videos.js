$(document).on('turbolinks:load', function() {
  $(document).on('ajax:success', '.add-video', function(e) {
    $('.new-video-form-container').html(e.detail[2].responseText)
  })

  previous = ''
  $(document).on('ajax:success', '.new-video-form', function(e) {
    if (previous != e.detail[2].responseText) {
      $('.videos').append(e.detail[2].responseText)
      $(this).remove()
      previous = e.detail[2].responseText
    }
  })
  $(document).on('ajax:error', '.new-video-form', function(e) {
    $('.new-video-form-container').html(e.detail[2].responseText)
  })

  $(document).on('ajax:success', '.edit-video', function(e) {
    $(this).siblings('.edit-video-form-container').html(e.detail[2].responseText)
  })

  $(document).on('ajax:success', '.edit-video-form', function(e) {
    $(this).closest('.video').replaceWith(e.detail[2].responseText)
  })

  $(document).on('ajax:success', '.delete-video', function() {
    $(this).closest('.video').remove()
  })
})