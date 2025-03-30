class UsersHaveAndBelongToManyRoles < ActiveRecord::Migration[6.1]
  def self.up
    create_table :roles_users, :id => false do |t|
      t.references :role, :user
    end
	
	user = User.new(:username => "bigcheese", :password => "password123")
    user.roles << Role.find_by_name("Admin");
	user.save
	
  end

  def self.down
    drop_table :roles_users
  end
end
