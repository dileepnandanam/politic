$(document).on('turbolinks:load', function() {
	$('.new-group-post').on('ajax:success', function(e) {
		new_post = $('.new-post')
		$('.new-post').html(e.detail[2].responseText)
		$(new_post).find('.open-image-upload').on('click', function(e) {
			e.preventDefault()
			$(this).siblings('.image-upload').removeClass('d-none')
		})
	})

	$('.questions-container').on('ajax:success', '.delete-post', function(e) {
		$(this).closest('.group-post, .comment').remove()
	})

	$('.questions-container').on('ajax:success', '.cast-vote', function(e) {
		$(this).closest('.comment-actions').replaceWith(e.detail[2].responseText)
	})
	
	$('.questions-container').on('ajax:success', '.new-comment-link', function(e) {
		$(this).closest('.comment-actions').siblings('.new-comment').html(e.detail[2].responseText)
	})

	$('.questions-container').on('ajax:success', '.comment-form', function(e) {
		$(this).closest('.new-comment').siblings('.comments-container').removeClass('d-none')
		$(this).closest('.new-comment').siblings('.comments-container').children('.comments').prepend(e.detail[2].responseText)
		$(this).closest('.new-comment').siblings('.comments-container').removeClass('d-none')
		$('.comment-form').remove()
	})

    $('.questions-container').on('ajax:success', '.comment .expand-comment', function(e) {
    	$($(this).closest('.comment').find('.comments-container')[0]).html(e.detail[2].responseText)
    	$($(this).closest('.comment').find('.comments-container')[0]).removeClass('d-none')
    })
    $('.questions-container').on('ajax:success', '.post > div > .expand-comment', function(e) {
    	$($(this).closest('.post').find('.comments-container')[0]).html(e.detail[2].responseText)
    	$($(this).closest('.post').find('.comments-container')[0]).removeClass('d-none')
    })

    $('.questions-container').on('ajax:success', '.view-more', function(e, data, status, xhr) {
    	$(this).replaceWith(e.detail[2].responseText)
    })

    $(document).on('ajax:success', '.group-post-form, .post-form, .survey-form', function(e, data, status, xhr) {
      $('.posts').prepend(e.detail[2].responseText)
      $(this).hide()
    }).on('ajax:error', function(e, data, status, xhr) {
      $('.group-post-form, .post-form').replaceWith(e.detail[2].response)
    })
})
