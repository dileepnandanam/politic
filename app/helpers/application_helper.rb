module ApplicationHelper
  def display_for_bot
  	user_agent =  request.env['HTTP_USER_AGENT'].downcase
  	if user_agent.index('googlebot')
      yield
  	end
  end

  def default_banner
    %{https://media.architecturaldigest.com/photos/5ced629704c41e1a9b9a8bcf/16:9/w_1280,c_limit/Bugatti-LVN-7%2520%255BBugatti%255D.jpg}
  end

  def default_background
    'https://komonews.com/resources/media/46ac9d95-54a7-4cea-829d-8834c73f293b-large16x9_190207_loz_snowfall_sunset_1940.jpg?1549572251633'
  end
end
