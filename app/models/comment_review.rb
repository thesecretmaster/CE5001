class CommentReview < ApplicationRecord
  belongs_to :review_result
  belongs_to :user
  belongs_to :comment
end
