initMasonry = function() {
	}
$(document).on('turbolinks:load', function() {

	search = function() {
		query = $('.search input').val()
		if(!query)
			return
		$.ajax({
			url: $(this).data('url'),
			data: {
				query: query
			},
			success: function(data) {
				$('.questions, .posts').html(data)
				prepare_asinc_reload()
			}
		})
	}
	auto_suggest = function() {
		query = $('.search input').val()
		if(!query)
			return
		$.ajax({
			url: '/posts/search_suggestions',
			data: {
				query: query
			},
			success: function(data) {
				$('.suggestions').html(data)
				$('.suggestions').removeClass('d-none')
			},
			error: function() {
				$('.suggestions').addClass('d-none')
			}
		})
	}
	$('body').click(function(){$('.suggestions').addClass('d-none')})
	$('.search input').keyup($.debounce(1250, search))
	$('.search input').keyup(auto_suggest)
	initMasonry()

	$('.questions').on('ajax:success', '.view-more-questions', function() {
		$('#masonry-container').masonry('reloadItems')
		initMasonry()
	})

	$('.gender_form').find('input').on('change', function() {
		$(this).closest('form').submit().remove()
	})

	$(document).on('click', '.close-cancel', function() {
		$(this).closest('.preview').addClass('d-none')
	})

  
})