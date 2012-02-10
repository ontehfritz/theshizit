class AddIp < ActiveRecord::Migration
  def up
    add_column :contents, :ip, :string
    add_column :comments, :ip, :string
    add_column :categories, :ip, :string 
  end

  def down
  end
end
