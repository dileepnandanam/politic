class ProductTagsController < ApplicationController
  def index
    if params[:query].present?
      @product_tags = ProductTag.where("name like '%#{params[:query]}%'").all
    else
      @product_tags = ProductTag.where(parent_id: params[:parent_id])
    end  

    if request.format.html?
      render 'index'
    else
      render partial: 'product_tags', locals: {product_tags: @product_tags}, alyout: false
    end
  end

  def create
    if current_user.admin?
      @tag = ProductTag.create(product_tag_params)
      render partial: 'product_tag', locals: {t: @tag} and return
    end
  end

  def product_tag_params
    params.require(:product_tag).permit(:parent_id, :name)
  end
end
