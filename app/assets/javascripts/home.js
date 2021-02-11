initMasonry = function() {
	}
$(document).on('turbolinks:load', function() {

	search = function(input, target) {
		query = $(input).val()
		if(!query)
			return
		$.ajax({
			url: $(input).data('url'),
			data: {
				query: query
			},
			success: function(data) {
				$(target).html(data)
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
	$('.search input').keyup($.debounce(1250, function(){search('.search input:focus', '.questions')}))
	$('.main-search input').keyup($.debounce(1250, function(){search('.main-search input:focus', '.posts')}))
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