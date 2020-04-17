class PicturesController < ApplicationController
  def create
    @picture = current_user.galeries.find(picture_params[:galery_id]).pictures.create picture_params
    render partial: 'picture', locals: {picture: @picture}
  end

  def destroy
    @picture = Picture.find(params[:id])
    if current_user.galeries.include? @picture.galery
      @picture.delete
      render plain: 'deleted', status: 200 and return
    else
      render plain: 'access_restricted', status: 404
    end
  end

  protected

    def picture_params
      params.require(:picture).permit(:img, :galery_id)
    end
end
