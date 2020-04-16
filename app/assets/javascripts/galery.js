$(document).on('turbolinks:load', function() {
  $(document).on('ajax:success', '.new-galery', function(e) {
    $('.galery-form-container').html(e.detail[2].responseText)
    $('.cancel').click(function(e) {
      e.preventDefault()
      $(this).closest('form').remove()
    })
  })

  $(document).on('ajax:success', '.galery-form', function(e) {
    $('.galeries-container').prepend(e.detail[2].responseText)
    %(this).remove()
  })
})