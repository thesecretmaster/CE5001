class CommentReview < ApplicationRecord
  belongs_to :review_result
  belongs_to :comment
  belongs_to :post_review
end
