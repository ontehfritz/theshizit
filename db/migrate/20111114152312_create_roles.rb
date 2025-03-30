class CreateRoles < ActiveRecord::Migration[6.1]
  def self.up
    create_table :roles do |t|
      t.string :name
      t.timestamps
    end
	
	Role.create :name => "Admin"
	Role.create :name => "Moderator"
	
  end
 
  def self.down
    drop_table :roles
  end
end
