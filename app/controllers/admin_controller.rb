class AdminController < ApplicationController
  before_action :require_admin

  def db_dump
    DatabaseDumpJob.perform_later
    # flash[:success] = 'A database dump task has been queued'
    render json: {status: 'success'}, status: :ok
  end

  private

  def require_admin
    unless current_user && current_user.admin
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
