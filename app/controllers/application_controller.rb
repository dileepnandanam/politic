class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  #before_action :redirect_to_affiliated_site
  before_action :set_flag

  #before_action :set_https

  def set_https
    if Rails.env != "development" && false
      unless request.url.starts_with?('https')
        redirect_to request.url.gsub('http', 'https') and return
      end
    end
  end

  def connections_for(user)
  	connections = (
      user.responses.where(accepted: true).map(&:responce_user) +
      user.posted_responses.where(accepted: true, group_id: nil).map(&:user)
    ).uniq
  end



  protected
    def redirect_to_affiliated_site
      affiliation = Affiliation.where(name: params[:permalink]).first
      if affiliation.present?
        return redirect_to affiliation.url
      end
    end

    def check_user
      unless current_user
        if request.format.html?
          redirect_to access_restricted_path and return
        else
          render 'home/access_restricted', layout: false
        end
      end
    end

    def authenticate_user!
      unless current_user.present?
        session[:after_sign_in_path] = request.url
        redirect_to new_user_session_path
      end
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :image, :name, :pin])
      devise_parameter_sanitizer.permit(:sign_in, keys: [:email, :password, :password_confirmation, :image, :name, :pin])
    end

    def set_flag
      @flag = 'active'
    end

  def survey_tags(survey)
    return '' if survey.nil?
    survey_tags = "#{survey.name} #{survey.description}"
    question_tags = survey.questions.map{|q| q.text}.join(' ')
    option_tags = survey.questions.map{|q| q.options.map(&:name)}.flatten.join(' ')
    "#{survey_tags} #{question_tags} #{option_tags}"
  end

  def tag_survey(survey, post)
    total_tags = "#{post.survey_tags} #{survey_tags(survey)}".split(' ').uniq.join(' ')
    post.update(survey_tags: total_tags)
  end

  def tag_site(site, post)
    site_title_tags = site.posts.map(&:title).join(' ')
    site_text_tags = site.posts.map(&:text).join(' ')
    site_tags = "#{site.name} #{site.description}"
    post.update(site_tags: "#{site_title_tags} #{site_text_tags} #{site_tags}")
  end

  def tag_galery(galery, post)
    if @post.group_id.nil?
      parents = [post]
    else
      parents = post.group.welcome_posts
    end
    parents.map{|p| p.update galery_tags: "#{post.galery_tags} #{galery.name} #{galery.description}".split(' ').uniq.join(' ')}
  end

  def tag_picture(picture, post)
    if post.group_id.nil?
      parent = [post]
    else
      parent = post.group.welcome_posts
    end
    parent.map{ |p| p.update picture_tags: "#{post.picture_tags} #{picture.caption} #{survey_tags(picture.survey)}".split(' ').uniq.join(' ') }
  end
end
