present_survey = function() {
  $.each($('.survey-container'), function(i, elem) {
    id = $(elem).data('id')
    url = '/surveys/' + id + '/survey_responses/new'
    $.ajax({
      url: url,
      success: function(data) {
        $(elem).html(data)
      }
    })
  })
}
bind_survey_pin = function() {
  $('.survey-select').click(function(e) {
    $(this).siblings('.survey-select-container').removeClass('d-none')
  })
}

bind_post = function() {
  $(document).on('ajax:success', '.group-post-form, .post-form', function(e, data, status, xhr) {
    $(document).off('ajax:success', '.group-post-form, .post-form')
    $(this).remove()
    $('.posts-container').prepend(e.detail[2].responseText)
    bind_post()
    bind_survey_pin()
  }).on('ajax:error', function(e, data, status, xhr) {
    $('.group-post-form, .post-form').replaceWith(e.detail[2].response)
  })
}
bind_post()
$(document).on('turbolinks:load', function() {
  
bind_survey_pin()

	$('.new-group-post').on('ajax:success', function(e) {
		new_post = $('.new-post')
		$('.new-post').html(e.detail[2].responseText)
		$(new_post).find('.open-image-upload').on('click', function(e) {
			e.preventDefault()
			$(this).siblings('.image-upload').removeClass('d-none')
		})
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
    })
    
    $(document).on('ajax:success', '.survey-select-form', function(e) {
      $(this).closest('.survey-select-container').siblings('.pin-survey-ack').html(e.detail[0]['ack'])
      $(this).closest('.post-body').find('.survey-container').data('id', e.detail[0]['id'])
      $(this).closest('.survey-select-container').addClass('d-none')
      present_survey()
    })

    present_survey()
    $(document).on('ajax:success', '.survey-select-form', function(e) {
      $(this).closest('.post-body').find('.survey-select-container').data(id, e.detail[0].id)
      present_survey()
    })

    $(document).on('ajax:success', '.feature', function(e) {
      $(this).replaceWith(e.detail[2].responseText)
    })
})
