class AddColumnsforVoting < ActiveRecord::Migration
  def up
     add_column :contents, :vote, :integer
     add_column :comments, :vote, :integer
  end

  def down
    remove_column :contents, :vote
    remove_column :comments, :vote
  end
end
