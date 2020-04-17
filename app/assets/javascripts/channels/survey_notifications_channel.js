survey_notification_subscribed = null
$(document).on('turbolinks:load', function() {
  audio = new Audio($('.response-notif').attr('src'));
  
  if(survey_notification_subscribed == null) {
    App.cable.subscriptions.create("ApplicationCable::SurveyNotificationsChannel", {
      received(data) {
        audio.play()
        $('.model-response-viewer').append(data.message)
      }
    })
    survey_notification_subscribed = 1
  }
})