$(document).on('turbolinks:load', function() {

  $('.free').click(function(e) {
    locate_post()
    e.preventDefault()
  })

  $('.busy').click(function(e) {
    vanish_post_location()
    e.preventDefault()
  })
  
  $('.i-am-here').click(function(e) {
    locate_me()
    e.preventDefault()
  })
})


locate_me = function() {
  navigator.geolocation.getCurrentPosition(send_user_location);
}

locate_post = function() {
  navigator.geolocation.getCurrentPosition(send_post_location);
}

send_post_location = function(position) {
  var id = $('.post').data('id')
  $.ajax({
    url: '/posts/' + id + '/locate',
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    method: 'PUT',
    data: {
      lat: position.coords.latitude,
      lngt: position.coords.longitude
    },
    success: function() {
      $('.free').toggleClass('d-none')
      $('.busy').toggleClass('d-none')

    }
  })
}

vanish_post_location = function() {
  var id = $('.post').data('id')
  $.ajax({
    url: '/posts/' + id + '/vanish',
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    method: 'PUT',
    success: function() {
      $('.free').toggleClass('d-none')
      $('.busy').toggleClass('d-none')

    }
  })
}

send_user_location = function(position) {
  $.ajax({
    url: '/users/locate',
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    method: 'PUT',
    data: {
      lat: position.coords.latitude,
      lngt: position.coords.longitude
    }
  })
}
