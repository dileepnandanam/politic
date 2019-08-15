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
end
