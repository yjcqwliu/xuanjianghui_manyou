class CreateMailRemindings < ActiveRecord::Migration
  def self.up
    create_table :mail_remindings do |t|
	  t.integer :activity_id
	  t.string :title, :limit => 200
	  t.string :link, :limit => 50
	  t.string :start_time, :limit => 30
	  t.string :end_time, :limit => 30
	  t.timestamp :remind_time
	  t.boolean :done, :limit => 3
	  t.string :mailbox, :limit => 50
	  t.string :act_subject, :limit => 200
	  t.integer :user_id
    end
	add_index :mail_remindings, :activity_id
	add_index :mail_remindings, :user_id
  end

  def self.down
    drop_table :mail_remindings
  end
end
