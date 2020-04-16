class GaleriesController < ApplicationController
  def new
    @galery = Galery.new
    render 'new', layout: false
  end

  def edit
    @galery = Galery.find(params[:id])
    render 'new', layout: false
  end

  def update
    @galery = current_user.galeries.find(params[:id])
    if @galery.update(galery_params)
      render 'galery', layout: false;
    else
      render 'new'
    end    
  end

  def create
    @galery = Galery.new galery_params
    if @galery.save
      render partial: 'galery', locals: {galery: @galery} , layout: false
    else
      render 'new', layout: false
    end
  end

  def destroy
    
  end

  protected

    def galery_params
      params.require(:galery).permit(:name, :post_id)
    end
end
