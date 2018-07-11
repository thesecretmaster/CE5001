class CommentController < ApplicationController
  before_action :require_login

  def evaulate
  end

  private

  def require_login
    unless current_user
      flash[:error] = "You must be logged in to access this section"
      redirect_to login_path
    end
  end

  def current_user
    if session[:user_id]
       User.find(session[:user_id])
    else
      nil
    end
  end
end
