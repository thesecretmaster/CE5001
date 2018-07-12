class AddPeekedToPostReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :post_reviews, :peeked, :boolean, default: false
  end
end
