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

  $('.filter-response-link').click(function(e) {
    $('.filter-response-link').toggleClass('d-none', 500)
  })

  $(document).on('ajax:success', '.select-chat', function(e) {
    $('.chats').html(e.detail[2].responseText)
    initChat()
  })

  $.ajax({
    url: $('.chat-container').data('url'),
    method: 'GET',
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    success: function(data) {
      $('.chat-container').html(data)
      initChat()
    }
  })

  bindDeleteNotification = function() {
    $('.notification').click(function() {
      notif = $(this)
      $.ajax({
        url: '/notifications/' + $(notif).data('id'),
        method: 'DELETE',
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        success: function(data) {
          $(notif).remove()
        }
      })
    })
  }
  
})


