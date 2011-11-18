class CreateIts < ActiveRecord::Migration
  def change
    create_table :its do |t|
	  t.string :name
	  t.text :message
	  t.integer :categories_count, :default => 0
	  t.boolean :is_current
      t.timestamps
    end
	
	It.create :name => "Shiz BANG!", :message => "1st Shiz period - Archive 30 days - new shiz begins decemeber 1", :is_current => true
  end
end
