class AddSeIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :se_id, :bigint
  end
end
