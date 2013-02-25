class CreateEventUsers < ActiveRecord::Migration
  def change
    create_table :event_users do |t|
      t.integer :event_model_id
      t.integer :user_id
    end

  end
end
