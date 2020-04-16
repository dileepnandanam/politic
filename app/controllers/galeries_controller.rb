class GaleriesController < ApplicationController
  def new
    render 'new', layout: false
  end

  def edit
    render 'new', layout: false
  end

  def update
    @galery = current_user.posts.find(:post_id)
    
  end

  def create

  end

  def destroy
    
  end

  protected

    def galery_params
      params.require(:galery).permit(:name, :page_id)
    end
end
