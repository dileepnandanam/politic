$(document).on('turbolinks:load', function() {
  App.cable.subscriptions.create("ApplicationCable::SurveyNotificationsChannel", {
    received(data) {
      alert(data.survey_name + ' has' + ' one response from ' + data.sender_name)
    }
  })
})