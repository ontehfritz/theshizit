class AddCommentNumber < ActiveRecord::Migration[6.1]
  def up
    add_column :comments, :comment_number, :integer, :default => 0
  end

  def down
    
  end
end
