$(document).on('turbolinks:load', function() {
  locate_me()

  $('.free').click(function(e) {
    locate_me()
    e.preventDefault()
  })

  $('.busy').click(function(e) {
    vanish()
    e.preventDefault()
  })

})

locate_me = function() {
  navigator.geolocation.getCurrentPosition(locate_user);
}

locate_user = function(position) {
  $.ajax({
    url: '/users/locate',
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

vanish = function() {
  $.ajax({
    url: '/users/vanish',
    beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
    method: 'PUT',
    success: function() {
      $('.free').toggleClass('d-none')
      $('.busy').toggleClass('d-none')

    }
  })
}
