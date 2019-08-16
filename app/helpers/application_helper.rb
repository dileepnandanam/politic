module ApplicationHelper
  def display_for_bot
  	user_agent =  request.env['HTTP_USER_AGENT'].downcase
  	if user_agent.index('googlebot')
      yield
  	end
  end

  def default_banner
    %{https://www.readersdigest.ca/wp-content/uploads/sites/14/2013/03/6-facts-to-know-before-owning-a-puppy.jpg}
  end

  def default_background
    'https://komonews.com/resources/media/46ac9d95-54a7-4cea-829d-8834c73f293b-large16x9_190207_loz_snowfall_sunset_1940.jpg?1549572251633'
  end
end
