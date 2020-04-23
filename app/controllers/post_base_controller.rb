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

  def search
    if request.format.html?
      redirect_to root_path(q: params[:q])
    else
      if params[:q].present?
        @posts = Post.search(params[:q], params[:group_id], orientation, params[:order]).paginate(page: params[:page], per_page: 20)
        @count = Post.search_count params[:q], orientation
        #if @posts.blank? || @posts.next_page.blank?
        if params[:crawl].present?
          Searcher.perform_later params[:q]
        elsif params[:random].present?
          @posts = Post.normal.with_orientation(orientation).order(Arel.new('random()')).paginate(per_page: 20, page: 1)
        end
      else
        @posts = Post.normal.with_orientation(orientation).paginate(per_page: 20, page: params[:page])
      end
      render 'search', layout: false
    end
  end
  
  protected

  def preview(text)
    MarkdownRenderer.render(text)
  end
end