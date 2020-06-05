$(document).on('turbolinks:load', function() {
  audio = new Audio($('.response-notif').attr('src'));
  App.cable.subscriptions.create("ApplicationCable::NotificationsChannel", {
    received(data) {
      audio.play()
    }
  })
})