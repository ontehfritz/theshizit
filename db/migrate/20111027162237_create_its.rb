class CreateIts < ActiveRecord::Migration[6.1]
  def change
    create_table :its do |t|
	  t.string :name
	  t.text :description
	  t.integer :categories_count, :default => 0
	  t.boolean :locked
	  t.boolean :is_default
    t.timestamps
  end
	
	It.create :name => "BETA test!", :description => "testing the shizit, post your shiz", 
	         :is_default => true, :locked => false
  end
end
