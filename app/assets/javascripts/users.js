$(document).on('turbolinks:load', function() {
  $(document).on('ajax:success', '.monitor-form', function(e) {
    $('form').html(e.detail[2].responseText)
  })
})