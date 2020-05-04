class Groups::Questions::OptionsController < ApplicationController
  before_action :find_parents
  def new
    @option = Option.new
    render 'new', layout: false
  end

  def create
    @option = @question.options.new(option_params)
    if @option.save
      @group.welcome_posts.map{|p| p.update_tag_set}
      render 'option', layout: false, status: 200
    else
      render 'new', layout: false, status: 422
    end
  end

  def edit
    @option = @question.options.find(params[:id])
    render 'edit', layout: false
  end

  def update
    @option = @question.options.find(params[:id])
    if @option.update(option_params)
      @group.welcome_posts.map{|p| p.update_tag_set}
      render 'option', layout: false, status: 200
    else
      render 'edit', layout: false, status: 422
    end
  end

  def destroy
    @question.options.find(params[:id]).delete
    @group.welcome_posts.map{|p| p.update_tag_set}
  end

  protected

  def find_parents
    @group = current_user.owned_groups.find(params[:group_id])
    @question = @group.questions.find(params[:question_id])
  end

  def option_params
    params.require(:option).permit(:name, :question_id)
  end
end