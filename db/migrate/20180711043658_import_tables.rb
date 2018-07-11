class ImportTables < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.text :body
      t.bigint :se_id
      t.integer :post_type
      t.datetime :se_creation_date
      t.integer :poster_rep
      t.text :title
      t.text :link
    end

    create_table :comments do |t|
      t.text :body
      t.text :link
      t.bigint :se_id
      t.integer :score
      t.integer :commenter_rep
      t.datetime :se_creation_date
      t.references :post, foreign_key: true
    end
  end
end
