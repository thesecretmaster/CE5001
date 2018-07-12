class CommentController < ApplicationController
  before_action :require_login

  def evaluate
    db = Rails.configuration.database_configuration[Rails.env]["adapter"]
    @post = Post.left_joins(:post_reviews).where.not(post_reviews: {user_id: current_user.id}).or(Post.left_joins(:post_reviews).where(post_reviews: {id: nil})).order(Arel.sql(db == 'mysql2' ? "RAND()" : "RANDOM()")).first
    redirect_to action: :done unless @post.present?
    @comments = @post.comments.sort_by(&:se_creation_date)
    post_review = current_user.post_reviews.new(review_loaded: DateTime.now, post: @post)
    if post_review.save
      render :evaluate, status: :ok
    else
      render status: 500, nothing: true
    end
  end

  def feedback
    post = Comment.find(params[:comments].keys.first).post
    pr = post.post_reviews.find_by(user: current_user)
    comments = params.require(:comments).permit(post.comments.map { |c| c.id.to_s }).to_h
    Rails.logger.info comments
    if pr.user_id == current_user.id && pr.update(review_completed: DateTime.now)
      Comment.transaction do
        comments.all? do |id, feedback|
          comment = Comment.find(id)
          cr = CommentReview.new(post_review: pr, review_result_id: feedback, comment: comment)
          rval = cr.save
          Rails.logger.info(cr.errors.full_messages)
          rval
        end
      end
    end
    redirect_to action: :evaluate
  end

  def post_redirect
    pr = PostReview.where(user: current_user, post_id: params[:id]).order(:created_at).last
    pr.update(peeked: true)
    redirect_to pr.post.link
  end

  def done; end

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
