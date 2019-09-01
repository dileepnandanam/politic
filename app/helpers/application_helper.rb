module ApplicationHelper
  def display_for_bot
  	user_agent =  request.env['HTTP_USER_AGENT'].downcase
  	if user_agent.index('googlebot')
      yield
  	end
  end

  def default_banner
    %{https://media2.giphy.com/media/A06UFEx8jxEwU/source.gif}
  end

  def default_background
    'https://komonews.com/resources/media/46ac9d95-54a7-4cea-829d-8834c73f293b-large16x9_190207_loz_snowfall_sunset_1940.jpg?1549572251633'
  end
end
