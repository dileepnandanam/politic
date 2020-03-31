$(document).on('turbolinks:load', function() {
  audio = new Audio($('.response-notif').attr('src'));
  App.cable.subscriptions.create("ApplicationCable::SurveyNotificationsChannel", {
    received(data) {
      audio.play()
      $('.model-response-viewer').append(data.link)
    }
  })
})