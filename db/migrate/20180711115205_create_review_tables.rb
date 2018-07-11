class CreateReviewTables < ActiveRecord::Migration[5.2]
  def change
    create_table :post_reviews do |t|
      t.references :user, foreign_key: true
      t.references :post, foreign_key: true
      t.datetime :review_loaded
      t.datetime :review_completed

      t.timestamps
    end

    create_table :review_results do |t|
      t.text :name

      t.timestamps
    end

    create_table :comment_reviews do |t|
      t.references :review_result, foreign_key: true
      t.references :comment, foreign_key: true
      t.references :post_review, foreign_key: true

      t.timestamps
    end
  end
end
