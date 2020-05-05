class PhonesController < ApplicationController
  def new
    @phone = post.phones.new
    render 'new', layout: false
  end

  def edit
    @phone = post.phones.find(params[:id])
    render 'edit', layout: false
  end

  def create
    @phone = post.phones.new phone_params
    if @phone.save
      post.update_tag_set
      render partial: 'phones/phone', locals: {phone: @phone}, layout: false
    else
      render 'new', layout: false
    end
  end

  def update
    @phone = post.phones.find(params[:id])
    if @phone.update phone_params
      @phone.post.update_tag_set
      render partial: 'phones/phone', locals: {phone: @phone}, layout: false
    else
      render 'edit', layout: false
    end
  end

  def destroy
    @phone = post.phones.find(params[:id]).delete
    post.update_tag_set
  end



  protected

  def post
    current_user.posts.find(params[:post_id] || phone_params[:post_id])
  end

  def phone_params
    params.require(:phone).permit(:name, :number, :post_id)
  end
end