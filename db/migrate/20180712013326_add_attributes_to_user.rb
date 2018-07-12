class AddAttributesToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :user_type, :string
    add_column :users, :reputation, :bigint
    add_column :users, :question_count, :bigint
    add_column :users, :answer_count, :bigint
  end
end
