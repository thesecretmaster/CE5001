class AddCommeterNameToComments < ActiveRecord::Migration[5.2]
  def change
    add_column :comments, :commenter_name, :text
  end
end
