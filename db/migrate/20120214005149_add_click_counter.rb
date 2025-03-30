class AddClickCounter < ActiveRecord::Migration[6.1]
  def up
    add_column :contents, :click_count, :integer, :default => 0
    add_column :categories, :click_count, :integer, :default => 0
  end

  def down
  end
end
