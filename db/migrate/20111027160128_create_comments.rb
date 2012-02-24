class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
  	  t.text :theshiz
  	  t.boolean :in_recycling, :default => false
  	  
  	  t.references :user
  	  t.references :content
  	  t.references :tone
      t.timestamps
    end
  end
end
