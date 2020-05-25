class VideosController < ApplicationController
  def new
    @post = current_user.posts.find(params[:post_id])
    @video = @post.videos.new
    render 'new', layout: false
  end

  def edit
    @post = current_user.posts.find(params[:post_id])
    @video = @post.videos.find(params[:id])
    render 'edit', layout: false
  end

  def create
    @video = current_user.posts.find(video_params[:post_id]).videos.new video_params
    if @video.save
      @post = @video.post
      @post.update_tag_set
      render partial: 'video', locals: {video: @video}
    else
      render 'new', layout: false, status: 422
    end
  end
  
  def update
    @video = current_user.posts.find(video_params[:post_id]).videos.find(params[:id])
    @video.update(video_params)
    @post = @video.post
    @post.update_tag_set
    render partial: 'video', locals: {video: @video}
  end
  
  def destroy
    @post = current_user.posts.find(params[:post_id])
    @post.videos.find(params[:id]).delete
    @post.update_tag_set
  end

  protected

    def video_params
      params.require(:video).permit(:iframe, :file, :caption, :post_id)
    end
end