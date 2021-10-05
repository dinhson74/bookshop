class UsersController < ApplicationController
  before_action :load_user, only: :show
  def show
    
  end

  def load_user
    @user = User.find_by(id: params[:id])
    return if @user
    render 'devise/shared/not_found'
  end
end
