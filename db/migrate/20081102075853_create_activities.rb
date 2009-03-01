class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
	  t.integer :calendar_id
	  t.integer :user_id
	  t.integer :place_id
	  t.integer :backplace_id
	  t.string :act_subject, :limit => 200
	  t.string :act_type, :limit => 12
	  t.string :act_place, :limit => 200
	  t.string :place_name, :limit => 100
	  t.string :access_type, :limit => 12
	  t.string :view_category, :limit => 12
	  t.string :category, :limit => 50
	  t.string :hot_category, :limit => 50
	  t.datetime :start_time
	  t.datetime :end_time
	  t.integer :act_year, :limit => 4
	  t.integer :act_month, :limit => 4
	  t.integer :act_week, :limit => 4
	  t.integer :act_day, :limit => 4
	  t.integer :act_hour, :limit => 4
	  t.datetime :updated_on
	  t.integer :end_year, :limit => 4
	  t.integer :end_month, :limit => 4
	  t.integer :end_day, :limit => 4
	  t.integer :end_week, :limit => 4
	  t.integer :end_hour, :limit => 4
	  t.integer :publish_ind, :limit => 2
	  t.string :act_location, :limit => 50
      t.integer :view_count
	  t.integer :comment_count
	  t.integer :rank
	  t.boolean :whole_day, :limit => 3
	  t.boolean :useless_count, :limit => 3
	  t.boolean :useful_count, :limit => 3
	  t.boolean :auth, :limit => 3
	  t.string :attach1, :limit => 100
	  t.string :pic_link, :limit => 250
	  t.integer :is_long   #原为smallint(6)类型，rails中没有对应的类型
	  t.timestamp :created_on
    end
	add_index :activities, :calendar_id, :name => "activity_fk1"
	add_index :activities, :view_count, :name => "act_index_3"
	add_index :activities, :updated_on, :name => "act_index_7"
	add_index :activities, [:start_time, :end_time, :access_type, :category], :name => "activity_index1"
	add_index :activities, [:user_id, :access_type, :end_time], :name => "act_index_5"
	add_index :activities, [:user_id, :access_type, :category, :end_time], :name => "act_index_4"
	add_index :activities, [:access_type, :category, :end_time], :name => "act_index_2"
	add_index :activities, [:place_id, :place_name], :name => "new_indexpp"
	add_index :activities, [:act_year, :act_month, :act_day], :name => "act_index_9"
	add_index :activities, [:access_type, :auth] , :name => "act_index"
  end
  

  def self.down
    drop_table :activities
  end
end
