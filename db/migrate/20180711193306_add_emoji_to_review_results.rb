class AddEmojiToReviewResults < ActiveRecord::Migration[5.2]
  def change
    add_column :review_results, :emoji, :string
  end
end
