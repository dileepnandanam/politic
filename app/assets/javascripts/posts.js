disable_for_unauthorized = function() {
  if(!$('.current-user-data').data('signed-in'))
    $('.quick-poll-container').find('input, textarea').prop('disabled', 'disabled')
  
  $.each($('.question.response-form.survey'), function(i, elem){
    if(!$(elem).data('anonymous') && !$('.current-user-data').data('signed-in')){
      $(this).find('input, textarea').prop('disabled', 'disabled')
    }
  })
}
present_survey = function() {
  $.each($('.survey-container'), function(i, elem) {
    id = $(elem).data('id')
    if(id == null)
      $(elem).html('')
    else {
      url = '/surveys/' + id + '/survey_responses/new'
      $.ajax({
        url: url,
        success: function(data) {
          $(elem).html(data)
          fix_checkbox_label()
          disable_for_unauthorized()
        }
      })
    }
  })
}

present_quick_poll = function() {
  $.each($('.quick-poll-container'), function(i, elem) {
    id = $(elem).data('id')
    if(id == null)
      $(elem).html('')
    else {
      url = '/quick_polls/' + id + '/quick_poll_responses/new'
      $.ajax({
        url: url,
        success: function(data) {
          $(elem).html(data)
          fix_checkbox_label()
          disable_for_unauthorized()
        }
      })
    }
  })
}

present_project = function() {
  $.each($('.project-container'), function(i, elem) {
    id = $(elem).data('id')
    if(id == null)
      $(elem).html('')
    else {
      url = '/groups/' + id + '/group_responses/new?pinned=true'
      $.ajax({
        url: url,
        success: function(data) {
          $(elem).html(data)
          fix_checkbox_label()
          disable_for_unauthorized()
        }
      })
    }
  })
}

bind_survey_pin = function() {
  $('.survey-select').click(function(e) {
    $(this).siblings('.survey-select-container').removeClass('d-none')
  })
}

bind_button_pin = function() {
  $('.button-select').click(function(e) {
    $(this).siblings('.button-select-container').removeClass('d-none')
  })
}


bind_quick_poll_pin = function() {
  $('.quick-poll-select').click(function(e) {
    $(this).siblings('.quick-poll-select-container').removeClass('d-none')
  })
}

bind_project_pin = function() {
  $('.project-select').click(function(e) {
    $(this).siblings('.project-select-container').removeClass('d-none')
  })
}
prepare_asinc_reload = function() {
  disable_for_unauthorized()
  present_survey()
  present_quick_poll()
  present_project()
  bind_survey_pin()
  bind_quick_poll_pin()
  bind_project_pin()
  bind_button_pin()
}
bind_post = function() {
  $(document).on('ajax:success', '.new-post-form', function(e, data, status, xhr) {
    $(document).off('ajax:success', '.new-post-form')
    $(this).remove()
    $('.posts-container').append(e.detail[2].responseText)
    $('.sub-nav-bar').removeClass('d-none')
    $('.my-pages').removeClass('d-none')
    bind_post()
    bind_survey_pin()
    bind_quick_poll_pin()
    bind_project_pin()
  }).on('ajax:error', function(e, data, status, xhr) {
    $('.group-post-form, .post-form').replaceWith(e.detail[2].response)
  })
}

fix_checkbox_label = function() {
  $.each($('input[type="checkbox"]'), function(i, elem) {
    $($(elem).next()).attr('for', $(elem).attr('id'))
  })
  $.each($('input[type="radio"]'), function(i, elem) {
    $($(elem).next()).attr('for', $(elem).attr('id'))
  })
}

bind_post()









$(document).on('turbolinks:load', function() {
  
bind_survey_pin()
bind_quick_poll_pin()
bind_project_pin()
bind_button_pin()
  

  $(document).on('ajax:success', '.project-form', function(e) {
    $('.nav-bar.unsigned').addClass('d-none')
    $('.nav-bar.signed').removeClass('d-none')
    window.location.href = e.detail[2].responseText
  })

  $(document).on('ajax:error', '.project-form', function(e) {
    $('.project-form').replaceWith(e.detail[2].responseText)
  })

	$('.new-bussiness-lik').on('ajax:success', function(e) {
		$('.new-post').html(e.detail[2].responseText)
    $('html, body').animate({
        scrollTop: $(".new-post").offset().top
    }, 500);

	})

  $(document).on('ajax:success', '.edit-post-link', function(e) {
    $(this).closest('.post').find('.edit-container').html(e.detail[2].responseText)
  })

  $(document).on('ajax:success', '.edit-post-form', function(e) {
    $(this).closest('.post').replaceWith(e.detail[2].responseText)
    prepare_asinc_reload()
  }).on('ajax:error', '.edit-container', function(e) {
    $('.edit-container').html(e.detail[2].responseText)
  })

	$(document).on('ajax:success', '.delete-post', function(e) {
		$(this).closest('.group-post, .comment').remove()
	})

	$(document).on('ajax:success', '.cast-vote', function(e) {
		$(this).closest('.comment-actions').replaceWith(e.detail[2].responseText)
	})
	
	$(document).on('ajax:success', '.new-comment-link', function(e) {
		$(this).closest('.comment-actions').siblings('.new-comment').html(e.detail[2].responseText)
	})

	$(document).on('ajax:success', '.comment-form', function(e) {
		$(this).closest('.new-comment').siblings('.comments-container').removeClass('d-none')
		$(this).closest('.new-comment').siblings('.comments-container').children('.comments').prepend(e.detail[2].responseText)
		$(this).closest('.new-comment').siblings('.comments-container').removeClass('d-none')
		$('.comment-form').remove()
	})

    $(document).on('ajax:success', '.comment .expand-comment', function(e) {
    	$($(this).closest('.comment').find('.comments-container')[0]).html(e.detail[2].responseText)
    	$($(this).closest('.comment').find('.comments-container')[0]).removeClass('d-none')
    })
    $(document).on('ajax:success', '.post > div > .expand-comment', function(e) {
    	$($(this).closest('.post').find('.comments-container')[0]).html(e.detail[2].responseText)
    	$($(this).closest('.post').find('.comments-container')[0]).removeClass('d-none')
    })

    $(document).on('ajax:success', '.view-more', function(e, data, status, xhr) {
    	$(this).replaceWith(e.detail[2].responseText)
      bind_survey_pin()
      present_survey()
      bind_quick_poll_pin()
      present_quick_poll()
      bind_project_pin()
      present_project()
    })
    
    $(document).on('ajax:success', '.survey-select-form', function(e) {
      $(this).closest('.survey-select-container').siblings('.pin-survey-ack').html(e.detail[0]['ack'])
      $(this).closest('.pin-select').siblings('.survey-container').data('id', e.detail[0]['id'])
      $(this).closest('.survey-select-container').addClass('d-none')
      present_survey()
    })

    present_survey()
    $(document).on('ajax:success', '.survey-select-form', function(e) {
      $(this).closest('.post-body').find('.survey-select-container').data(id, e.detail[0].id)
      present_survey()
    })

    $(document).on('ajax:success', '.post-select-form', function(e) {
      $(this).closest('.picture').replaceWith(e.detail[0].responseText)
    })

    $(document).on('ajax:success', '.quick-poll-select-form', function(e) {
      $(this).closest('.quick-poll-select-container').siblings('.pin-quick-poll-ack').html(e.detail[0]['ack'])
      $(this).closest('.post-body').find('.quick-poll-container').data('id', e.detail[0]['id'])
      $(this).closest('.quick-poll-select-container').addClass('d-none')
      present_quick_poll()
    })

    present_quick_poll()
    $(document).on('ajax:success', '.quick-poll-select-form', function(e) {
      $(this).closest('.post-body').find('.quick-poll-select-container').data(id, e.detail[0].id)
      present_quick_poll()
    })

    $(document).on('ajax:success', '.project-select-form', function(e) {
      $(this).closest('.project-select-container').siblings('.pin-project-ack').html(e.detail[0]['ack'])
      $(this).closest('.post-body').find('.project-container').data('id', e.detail[0]['id'])
      $(this).closest('.project-select-container').addClass('d-none')
      present_project()
    })

    present_project()
    $(document).on('ajax:success', '.project-select-form', function(e) {
      $(this).closest('.post-body').find('.project-select-container').data(id, e.detail[0].id)
      present_project()
    })

    $(document).on('ajax:success', '.feature', function(e) {
      $(this).replaceWith(e.detail[2].responseText)
    })

    $('.edit-social-link').click(function(e) {
      e.preventDefault()       
      $('.edit-social-link-form').removeClass('d-none')
    })
    $('.cancel-edit-social-link-form').click(function(e) {
      e.preventDefault()
      $(this).closest('.edit-social-link-form').addClass('d-none')
    })
    $(document).on('ajax:success', '.edit-social-links', function(e) {
      $(this).closest('.post').find('.social-links').replaceWith(e.detail[2].responseText)
      $(this).remove()
    })
    
    $(document).on('ajax:success', '.post-visibility', function(e) {
      $(this).closest('.post').replaceWith(e.detail[2].responseText)
    })

    $(document).on('ajax:success', '.style-buton', function(e) {
      $('.style-container').html(e.detail[0])
    })

    $('.components').sortable({
    handle: '.component-handle',
    stop: function() {
      $.ajax({
        data: $(this).sortable('serialize'),
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        url: $(this).data('url'),
        method: 'PUT'
      })
    }
  })
})
