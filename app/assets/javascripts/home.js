initMasonry = function() {
	}
$(document).on('turbolinks:load', function() {

	search = function() {
		query = $('.search input:focus').val()
		if(!query)
			return
		$.ajax({
			url: $(this).data('url'),
			data: {
				query: query
			},
			success: function(data) {
				$('.questions').html(data)
				prepare_asinc_reload()
			}
		})
	}

	main_search = function() {
		query = $('.main-search input:focus').val()
		if(!query)
			return
		$.ajax({
			url: $(this).data('url'),
			data: {
				query: query
			},
			success: function(data) {
				$('.posts').html(data)
				prepare_asinc_reload()
			}
		})
	}

	auto_suggest = function() {
		query = $('.main-search input:focus').val()
		if(!query)
			return
		$.ajax({
			url: '/posts/search_suggestions',
			data: {
				query: query
			},
			success: function(data) {
				if(data.length > 0){
					$('.suggestions').html(data)
				  $('.suggestions').removeClass('d-none')
			  } else
			    $('.suggestions').addClass('d-none')
			},
			error: function() {
				$('.suggestions').addClass('d-none')
			}
		})
	}
	$('body').click(function(){$('.suggestions').addClass('d-none')})
	$('.search input').keyup($.debounce(1250, search))
	$('.main-search input').keyup($.debounce(1250, main_search))
	$('.main-search input').keyup($.debounce(500, auto_suggest))
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

	color = ['yellow', 'red', 'orange', 'green', 'pink']
  light_switch = function(elem, i) {
  	$(elem).css('box-shadow','0px 0px 14px ' + color[i])
  	setTimeout(function() {light_switch(elem, (i+1)%color.length)}, 500)
  }
  //light_switch($('.devine-container'), 0)
})