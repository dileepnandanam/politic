class B2b::ProductsController < ApplicationController
  before_action :check_admin, only: [:create, :update, :destroy]
  def index
    @parent = ProductTag.find(params[:parent_id])
    @products = []
    iterate(@parent)
    @products = @products.flatten
  end

  def show
    @product = Product.find(params[:id])
    render 'show', layout: false
  end

  def create
    @product = Product.new product_params
    if @product.save  
      render partial: 'small_product', locals: {product: @product}, layout: false
    else
      render 'new', layout: false, status: 422
    end
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)  
      render partial: 'b2b/products/product', locals: {product: @product}, layout: false
    else
      render 'edit', layout: false, status: 422
    end
  end

  def edit
    @product = Product.find(params[:id])
    render 'edit', layout: false
  end

  def new
    @product = Product.new
    render 'new', layout: false
  end

  def destroy
    @product = Product.find(params[:id])
    @product.delete
    render plain: 'ok', status: 200
  end

  protected

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

  def check_admin
    unless current_user.admin?
      render 'home/access_restricted', layout: false and return
    end
  end

  def product_params
    params.require(:product).permit(:name, :price, :img, :product_tag_id)
  end
end