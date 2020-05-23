initChat = function() {
	var BindFormSubmit = function() {
		$('.chats').on('ajax:success', 'form', function(e) {
			$('.chats').off('ajax:success', 'form')
			$('.chat-thread').append(e.detail[2].responseText)
			$(this).find('textarea').val('')
			scroll_to_bottom()
		  BindFormSubmit()
		})  
	}
	BindFormSubmit()

  BindSend = function() {
		$('.chats').on('keypress', 'textarea', function(e) {
			$('.chats').off('keypress', 'textarea')
			if(e.which == 13)
				Rails.fire($(this).closest('form')[0], 'submit')
			BindSend()
		})
	}
	BindSend()

	$(document).on('click', '.imogee', function() {
		textarea = $(this).closest('.imogee-list').siblings('.form-group').find('textarea')
		$(textarea).val($(textarea).val() + $(this).data('imogee').trim())
	})

	scroll_to_bottom = function() {
		$('.chat-thread').scrollTop($('.chat-thread').prop('scrollHeight'))
	}
	scroll_to_bottom()
}
$(document).on('turbolinks:load', function() {
	

	$('.chat-thread').scrollTop($('.chat-thread').prop('scrollHeight'))

	$('.select-connection').on('ajax:success', function(e) {
		$('.chats').html(e.detail[2].responseText)
		scroll_to_bottom()
		$(this).find('.question').removeClass('have-new-chat')
		$(this).find('.unseen-count').addClass('d-none')
		$(this).find('.unseen-count').html('0')
	})

	
	initChat()
})