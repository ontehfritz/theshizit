class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :type_id
      t.string :type_name
      t.integer :parent_type_id
      t.references :user
      t.timestamps
    end
  end
end
