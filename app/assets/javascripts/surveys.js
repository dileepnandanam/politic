fix_radio = function() {
  $.each($('.form-check-input'), function(i, elem){
    $(elem).attr('id', i)
    $(elem).next('label').attr('for', i)
  })
}
$(document).on('turbolinks:load', function() {
  fix_radio()
  $(document).on('ajax:success', '.new-option', function(e) {
    $(this).siblings('.new-option-form').html(e.detail[2].responseText)
  })
  
  $(document).on('ajax:success', '.new-option-form > form', function(e) {
    $(this).closest('.new-option-form').siblings('.options').append(e.detail[2].responseText)
    $(this).remove()
    $('.hide-options').removeClass('d-none')
  })

  $(document).on('ajax:error', '.option-form', function(e) {
    $('this').html(e.detail[2].responseText)
  })

  $(document).on('ajax:success', '.delete-option', function(e) {
    $(this).closest('.option').remove()
  })

  $(document).on('ajax:success', '.answer-type-form', function(e) {
    $(this).closest('.question').replaceWith(e.detail[2].responseText)
    fix_radio()
  })

  $(document).on('ajax:success', '.edit-option', function(e) {
    $(this).siblings('.option-edit-form-container').html(e.detail[2].responseText)
  })
  $(document).on('ajax:success', '.option-edit-form-container > form', function(e) {
    $(this).closest('.option').replaceWith(e.detail[2].responseText)
  })

  $(document).on('change', 'input[name="question[answer_type]"]', function(e) {
    $(this).closest('form').find('input[type="submit"]').removeClass('d-none')
  })

  $('.hide-options').click(function() {
    $(this).addClass('d-none')
    $('.show-options').removeClass('d-none')
    $('.option').hide()
  })
  $('.show-options').click(function() {
    $(this).addClass('d-none')
    $('.hide-options').removeClass('d-none')
    $('.option').show()
  })
  
  $('.questions-container.reorderable-survey-questions').sortable({
    handle: '.survey-question-handle',
    stop: function() {
      $.ajax({
        data: $('.questions-container').sortable('serialize'),
        url: $(this).data('url'),
        method: 'PUT'
      })
    }
  })

  $('.options').sortable({
    handle: '.option-handle',
    stop: function() {
      $.ajax({
        data: $('.options').sortable('serialize'),
        url: '/groups/reorder_options',
        method: 'PUT'
      })
    }
  })

  $('.reorder-quick-poll-question').sortable({
    handle: '.quick-poll-question-handle',
    stop: function() {
      $.ajax({
        data: $('.reorder-quick-poll-question').sortable('serialize'),
        url: '/quick_polls/reorder',
        method: 'PUT'
      })
    }
  })
  
  $('.handle-response').click(function(e) {
    $('.handle-response').removeClass('d-none')
    $(this).addClass('d-none')
  })
  
  $(document).on('ajax:success', '.assign-user', function(e) {
    $(this).css('color', 'red')
  })
})

