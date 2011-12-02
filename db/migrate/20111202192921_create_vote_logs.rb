class CreateVoteLogs < ActiveRecord::Migration
  def change
    create_table :vote_logs do |t|
      t.integer :type_id
      t.string :type_name
      t.references :user
      t.timestamps
    end
  end
end
