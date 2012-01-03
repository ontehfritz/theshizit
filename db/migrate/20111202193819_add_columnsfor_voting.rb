class AddColumnsforVoting < ActiveRecord::Migration
  def up
     #add_column :contents, :vote, :integer, :default => 0
     #add_column :comments, :vote, :integer, :default => 0
  end

  def down
    #remove_column :contents, :vote
    #remove_column :comments, :vote
  end
end
