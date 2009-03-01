class CreateActTexts < ActiveRecord::Migration
  def self.up
    create_table :act_texts do |t|
      t.integer :activity_id
	  t.text :act_description
    end
	add_index :act_texts, :activity_id, :name => "act_index"
  end

  def self.down
    drop_table :act_texts
  end
end
