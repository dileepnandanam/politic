class PicturesController < ApplicationController
  def create
    @picture = current_user.galeries.find(picture_params[:galery_id]).pictures.create picture_params
    @post = @picture.galery.post
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

  def select_survey
    @picture = Picture.find(params[:id])
    if params[:picture][:survey_id].blank?
      @picture.update(survey_id: nil)
      render json: {
        ack: "No survey has got pinned to this post",
        id: nil
      } and return
    end
    @survey = current_user.surveys.find(params[:picture][:survey_id])
    @picture.update survey_id: @survey.id

    render json: {
      ack: "Pinning survey #{@survey.name}",
      id: @survey.id
    }
  end

  protected

    def picture_params
      params.require(:picture).permit(:img, :galery_id, :caption)
    end
end
