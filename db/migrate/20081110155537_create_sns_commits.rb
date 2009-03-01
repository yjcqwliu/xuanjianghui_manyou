class CreateSnsCommits < ActiveRecord::Migration
  def self.up
    create_table :sns_commits do |t|
      t.integer :sns_user_xid
	  t.integer :activity_id
	  t.text :content
	  t.integer :reply_xid
	  t.boolean :sented
      t.timestamps
    end
	add_index :sns_commits, :sns_user_xid
    add_index :sns_commits, :activity_id
    add_index :sns_commits, :updated_at
  end

  def self.down
    drop_table :sns_commits
  end
end 
