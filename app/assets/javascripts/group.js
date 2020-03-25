$(document).on('turbolinks:load', function() {
  $('.questions-container.reorderable-group-questions').sortable({
    handle: '.group-question-handle',
    stop: function() {
      $.ajax({
        data: $('.questions-container').sortable('serialize'),
        url: $(this).data('url'),
        method: 'PUT'
      })
    }
  })
})