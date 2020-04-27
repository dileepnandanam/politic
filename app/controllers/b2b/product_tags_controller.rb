class B2b::ProductTagsController < ApplicationController
  def index
    if params[:query].present?
      @product_tags = ProductTag.where("name like '%#{params[:query]}%'").all.map(&:children).flatten
    else
      if params[:parent_id].present?
        @parent = ProductTag.find(params[:parent_id])
        @products = []
        iterate(@parent)
        @products = @products.flatten.sort_by(&:price)
        @first_list = @products[0..10]
        @second_list = @products[11..-1]
      end
      @product_tags = ProductTag.where(parent_id: params[:parent_id])
    end  

    if request.format.html?
      render 'index'
    else
      render partial: 'product_tags', locals: {product_tags: @product_tags}, layout: false
    end
  end

  def create
    if current_user.admin?
      @tag = ProductTag.create(product_tag_params)
      render partial: 'product_tag', locals: {product_tag: @tag} and return
    end
  end

  def destroy
    ProductTag.find(params[:id]).delete
  end

  protected

  layout 'b2b'

  def iterate(tag)
    @products << tag.products
    if tag.children.all == []
      return
    else
      tag.children.each do |t|
        iterate(t)
      end
    end
  end

  def product_tag_params
    params.require(:product_tag).permit(:parent_id, :name)
  end
end