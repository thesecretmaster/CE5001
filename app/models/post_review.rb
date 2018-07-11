class PostReview < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :comment_reviews
end
