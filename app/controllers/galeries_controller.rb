class GaleriesController < ApplicationController
  before_action :check_user
  def new
    @galery = Galery.new
    render 'new', layout: false
  end

  def edit
    @galery = Galery.find(params[:id])
    render 'edit', layout: false
  end

  def update
    @galery = current_user.galeries.find(params[:id])
    @post = @galery.post
    if @galery.update(galery_params)
      @post.update_tag_set
      render partial: 'galery', locals: {galery: @galery}, layout: false;
    else
      render 'new'
    end    
  end

  def create

    @galery = current_user.posts.find(galery_params[:post_id]).galeries.new galery_params.merge(user_id: current_user.id)
    @post = @galery.post
    if @galery.save
      @post.update_tag_set
      render partial: 'galery', locals: {galery: @galery} , layout: false
    else
      render 'new', layout: false
    end
  end

  def destroy

    @galery = current_user.galeries.find(params[:id])
    @post = @galery.post
    @galery.delete
    @post.update_tag_set
  end

  protected

    def galery_params
      params.require(:galery).permit(:name, :post_id, :description, :column)
    end
end
