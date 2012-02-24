class AddCommentNumber < ActiveRecord::Migration
  def up
    add_column :comments, :comment_number, :integer, :default => 0
  end

  def down
    
  end
end
