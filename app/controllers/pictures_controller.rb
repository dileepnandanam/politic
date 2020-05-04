class PicturesController < ApplicationController
  def new
    @galery = current_user.galeries.find(params[:galery_id])
    @picture = @galery.pictures.new
    render partial: 'form', layout: false
  end

  def edit
    @galery = current_user.galeries.find(params[:galery_id])
    @picture = @galery.pictures.find(params[:id])
    render partial: 'form', layout: false
  end

  def create
    @picture = current_user.galeries.find(picture_params[:galery_id]).pictures.create picture_params
    @post = @picture.galery.post
    @post.update_tag_set
    render partial: 'picture', locals: {picture: @picture}
  end
  
  def update
    @picture = current_user.galeries.find(picture_params[:galery_id]).pictures.find(params[:id])
    @picture.update(picture_params)
    @post = @picture.galery.post
    @post.update_tag_set
    render partial: 'picture', locals: {picture: @picture}
  end

  def delete_image
    @image = ActiveStorage::Attachment.find(params[:id])
    @image.purge
    render plain: 'img deleted', status: 200
  end
  
  def destroy
    @picture = current_user.galeries.find(params[:galery_id]).pictures.find(params[:id])
    @post = @picture.galery.post
    @picture.delete
    @post.update_tag_set
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
    @post = @picture.galery.post
    @post.update_tag_set
    render json: {
      ack: "Pinning survey #{@survey.name}",
      id: @survey.id
    }
  end

  def select_post
    @picture = Picture.find(params[:id])
    if params[:picture][:linked_post_id].blank?
      @picture.update(linked_post_id: nil)
      render json: {
        ack: "No button has got pinned to this post",
        id: nil
      } and return
    end
    @post = current_user.posts.find(params[:picture][:linked_post_id])
    
    @picture.update linked_post_id: @post.id
    @picture.update linked_post_name: params[:picture][:linked_post_name]

    render partial: 'picture', locals: {picture: @picture}, status: 200 and return
    
  end

  protected

    def picture_params
      params.require(:picture).permit(:img, :galery_id, :caption, :linked_post_id, :linked_post_name)
    end
end
