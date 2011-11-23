class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :type_id
      t.string :type_name
      t.references :user
      
      t.timestamps
    end
  end
end
