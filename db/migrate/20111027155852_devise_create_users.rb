class DeviseCreateUsers < ActiveRecord::Migration[6.1]
  def self.up
    create_table(:users) do |t|
      ## database_authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## rememberable
      t.datetime :remember_created_at

      ## trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## custom
      t.string :username, null: false, default: ""

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
  end

  def self.down
    drop_table :users
  end
end
