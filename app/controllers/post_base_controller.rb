class PostBaseController < ApplicationController
  def update
    @post = Post.find(params[:id])
    @post.assign_attributes(post_params)
    if(@post.save)
      render plain: preview(@post.text)
    else
      render 'new', layout: false, status: 422
    end
  end
  
  protected

  def preview(text)
    MarkdownRenderer.render(text)
  end
end