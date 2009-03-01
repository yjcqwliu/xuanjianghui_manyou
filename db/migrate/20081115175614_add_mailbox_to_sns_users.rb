class AddMailboxToSnsUsers < ActiveRecord::Migration
  def self.up
  	add_column :sns_users, :mailbox, :string
  end

  def self.down
  	remove_column :sns_users, :mailbox
  end
end
