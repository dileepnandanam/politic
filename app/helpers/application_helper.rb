module ApplicationHelper
  def edit_mode(item)
    !params[:preview] && current_user == item.user
  end

  def admin
    session[:actual_user_id] == User.find_by_admin(true).id
  end
  
  def display_for_bot
  	user_agent =  request.env['HTTP_USER_AGENT'].downcase
  	if user_agent.index('googlebot')
      yield
  	end
  end

  def bot_request?
    user_agent = request.env['HTTP_USER_AGENT'].downcase
    user_agent.index('googlebot')
  end

  def display_name(obj, handle)
    if obj.name.present?
      obj.name
    else
      if current_user == (@group||@post).user && !params[:preview]
        "Untitled #{obj.class.name.camelize}"
      end
    end
  end

  def default_banner
    %{https://media2.giphy.com/media/A06UFEx8jxEwU/source.gif}
  end

  def default_background
    'https://komonews.com/resources/media/46ac9d95-54a7-4cea-829d-8834c73f293b-large16x9_190207_loz_snowfall_sunset_1940.jpg?1549572251633'
  end

  def image_tag_with_fallback(obj, handle)
    if obj.send(handle).attachment.present?
      image_tag(obj.send(handle), alt: obj.try(:alt_text))
    end
  end

  def remove_tag_with_fallback(obj, handle)
    if obj.send(handle).attachment.present?
      link_to 'Remove picture', delete_image_picture_url(obj.send(handle).id), method: :delete, remote: true, class: 'remove-image'
    end
  end

  def post_class(post)
    visibility_class = (!post.visible? && current_user != post.user || !post.visible? && params[:preview] ? 'd-none' : '')
    post_specific_class = "post_#{post.id}"
    "#{visibility_class} #{post_specific_class}"
  end

  def galery_class(galery)
    "galery_#{galery.id}"
  end

  def picture_class(picture)
    width_class = "col-sm-#{12/picture.galery.column}"
    "picture_#{picture.id} #{width_class}"
  end

  def meta_description
    "best " + [@description , @group.try(:banner_description), @post.try(:title), @group.try(:posts).try(:first).try(:title) , 'search palakkad for services nearby'].find(&:present?)
  end

  def meta_title
    "Top " + [@title, @group.try(:banner_title), @post.try(:title), @group.try(:posts).try(:first).try(:title), 'search palakkad'].find(&:present?)
  end
end
