class CreateSnsUsers < ActiveRecord::Migration
  def self.up
    create_table :sns_users do |t|
	  t.string :xid , :null => false, :limit => 30
      t.text :friend_ids
	  t.string :session_key
	  t.string :act_location, :limit => 50
      t.timestamps
    end
	add_index :sns_users, :xid
	add_index :sns_users, :act_location
	add_index :sns_users, :updated_at
  end

  def self.down
    drop_table :sns_users
  end
end
