class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
  	  t.string :theshiz
  	  t.integer :contents_count, :default => 0
  	  t.integer :active_contents_count, :default => 0
  	  t.boolean :is_nsfw
  	  t.boolean :in_recycling, :default => false
  	  
  	  t.references :it
  	  t.references :user
      t.timestamps
    end
  end
end