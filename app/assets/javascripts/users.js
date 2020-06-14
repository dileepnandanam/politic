$(document).on('turbolinks:load', function() {
  $(document).on('ajax:success', '.monitor-form', function(e) {
    $('form').html(e.detail[2].responseText)
  })

  sms_password_path = '/users/sms_password?email='
  $('.login-field').on('keyup', function() {
    show_link(this)
  })
})
show_link = function(that) {
  var email = $(that).val()
    $('.reset-phone-pass').attr('href', sms_password_path + email)
    if($(that).val().includes('@')) {
      $('.reset-email-pass').removeClass('d-none')
      $('.reset-phone-pass').addClass('d-none')
    }
    else {
      $('.reset-email-pass').addClass('d-none')
      $('.reset-phone-pass').removeClass('d-none')
    }
}