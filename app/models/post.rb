class Post < ApplicationRecord
  has_many :comments
  has_many :post_reviews
end
