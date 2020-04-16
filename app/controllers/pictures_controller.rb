class PicturesController < ApplicationController
  def create
    if current_user.posts.map { |post|
      post.galeries.map(&:id)
    }.flatten.include? picture_params[:galery_id].to_i
      @picture = Picture.create(picture_params)
      render partial: 'pictures/picture', locals: {picture: @picture}
    else
      render plain: 'access_restricted', status: 404
    end
  end

  def destroy
    Picture.find(params[:id]).delete
  end

  protected

    def picture_params
      params.require(:picture).permit(:img, :galery_id)
    end
end
