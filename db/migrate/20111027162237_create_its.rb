class CreateIts < ActiveRecord::Migration
  def change
    create_table :its do |t|
	  t.string :name
	  t.text :message
	  t.integer :categories_count, :default => 0
	  t.boolean :is_current
      t.timestamps
    end
	
	It.create :name => "BETA test!", :message => "Beta Test - new shiz period begins Decemeber 1", :is_current => true
  end
end
