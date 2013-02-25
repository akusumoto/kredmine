class CreateEventUserTables < ActiveRecord::Migration
  def change
    create_table :event_user_tables do |t|
      t.integer :event_model_id
      t.integer :event_user_id
    end

  end
end
