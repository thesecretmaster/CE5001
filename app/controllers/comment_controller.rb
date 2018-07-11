class CommentController < ApplicationController
  before_action :require_login

  def evaluate
    db = Rails.configuration.database_configuration[Rails.env]["adapter"]
    @post = Post.left_joins(:post_reviews).where.not(post_reviews: {user_id: current_user.id}).or(Post.left_joins(:post_reviews).where(post_reviews: {id: nil})).order(db == 'mysql' ? "RAND()" : "RANDOM()").first
    @comments = @post.comments
    post_review = current_user.post_reviews.new(review_loaded: DateTime.now, post: @post)
    if post_review.save
      render :evaluate, status: :ok
    else
      render status: 500, nothing: true
    end
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
