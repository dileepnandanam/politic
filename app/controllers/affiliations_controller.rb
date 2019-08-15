class AffiliationsController < ApplicationController
  before_action :check_user

  def index
    @affiliations = Affiliation.all
  end

  def create
    @affiliation = Affiliation.new(affiliation_params)
    @affiliation.save
    render 'affiliation', layout: false
  end

  def update
    @affiliation = Affiliation.find(params[:id])
    @affiliation.update(affiliation_params)
    render 'affiliation', layout: false
  end

  def destroy
    @affiliation = Affiliation.find(params[:id])
    @affiliation.delete
  end

  protected

  def check_user
    unless current_user && current_user.email == 'dileepsnandanam@gmail.com'
      redirect_to access_restricted_path and return
    end
  end

  def affiliation_params
    params.require(:affiliation).permit(:name, :url)
  end
end