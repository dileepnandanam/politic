$(document).on('turbolinks:load', function() {
  $('.questions-container.reorderable-group-questions').sortable({
    handle: '.group-question-handle',
    stop: function() {
      $.ajax({
        data: $(this).sortable('serialize'),
        url: $(this).data('url'),
        method: 'PUT'
      })
    }
  })

  $('.reorderable-group-post').sortable({
    handle: '.group-question-handle',
    stop: function() {
      $.ajax({
        data: $(this).sortable('serialize'),
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        url: $(this).data('url'),
        method: 'PUT'
      })
    }
  })

  $(document).on('ajax:success', '.project-form', function(e) {
    $(this).replaceWith(e.detail[2].responseText)
  })

  $('.filter-response-link').click(function(e) {
    $('.filter-response-link').toggleClass('d-none', 500)
  })
})


