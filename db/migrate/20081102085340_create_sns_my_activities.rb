class CreateSnsMyActivities < ActiveRecord::Migration
  def self.up
    create_table :sns_my_activities do |t|
	  t.integer :sns_user_id
	  t.integer :activity_id
	  t.boolean :join
	  t.boolean :interest
	  t.boolean :share
	  t.string :share_content

      t.timestamps
    end
	add_index :sns_my_activities, [:sns_user_id, :activity_id, :join]
	add_index :sns_my_activities, :activity_id
  end

  def self.down
    drop_table :sns_my_activities
  end
end
