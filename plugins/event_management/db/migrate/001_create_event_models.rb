class CreateEventModels < ActiveRecord::Migration
  def self.up
    create_table :event_models do |t|
#      t.column :event_model_id, :integer, :null => false
      t.column :project_id, :integer, :null => false
      t.column :event_owner_id, :integer, :null => false
      t.column :event_subject, :string
     	t.column :event_date, :datetime
		  t.column :str_event_date, :string
			t.column :updated_on, :datetime
			t.column :created_on, :datetime
			t.column :event_place_station, :string
      t.column :event_place, :string
      t.column :event_return_request_mail_type, :integer
      t.column :event_caption, :text
			t.column :last_update_user_id, :integer
    end
  end
  def self.down
    drop_table :event_models
  end
end
