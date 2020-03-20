bind_post = function() {
  $(document).on('ajax:success', '.group-post-form, .post-form', function(e, data, status, xhr) {
    $(document).off('ajax:success', '.group-post-form, .post-form')
    $(this).remove()
    $('.posts-container').prepend(e.detail[2].responseText)
    bind_post()
  }).on('ajax:error', function(e, data, status, xhr) {
    $('.group-post-form, .post-form').replaceWith(e.detail[2].response)
  })
}
bind_post()
$(document).on('turbolinks:load', function() {
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

    
})
