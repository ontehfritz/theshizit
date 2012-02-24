class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
  	  t.string :title
  	  t.text :theshiz
  	  t.string :file_type
      t.string :file_name
      t.binary :image_data, :limit => 10.megabyte
  	  t.string :type
  	  t.integer :comments_count, :default => 0
  	  t.integer :active_comments_count, :default => 0
  	  t.boolean :in_recycling, :default => false
  	  
  	  t.references :category
  	  t.references :user
      t.timestamps
    end
  end
end
