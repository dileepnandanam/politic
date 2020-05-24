initChat = function() {
	previous_chat_id = '0'
	var BindFormSubmit = function() {
		$(document).on('ajax:success', '.chats form', function(e) {
			$(document).off('ajax:success', '.chats form')
			if(parseInt($(e.detail[2].responseText).attr('id')) != previous_chat_id)
			{
			  $('.chat-thread').append(e.detail[2].responseText)
			  previous_chat_id = parseInt($(e.detail[2].responseText).attr('id'))
			}
			$(this).find('textarea').val('')
			scroll_to_bottom()
		  BindFormSubmit()
		})  
	}
	BindFormSubmit()

  BindSend = function() {
		$(document).on('keypress', '.chats textarea', function(e) {
			$(document).off('keypress', '.chats textarea')
			if(e.which == 13) {
  			Rails.fire($(this).closest('form')[0], 'submit')
			}
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

	
})