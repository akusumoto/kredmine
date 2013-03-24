class CreateEventAnswerData < ActiveRecord::Migration
  def self.up
    create_table :event_answer_data do |t|
      t.column :event_model_id, :integer
      t.column :answer_subject, :string
			t.column :on_created_time, :string
    end
  end

  def self.down
    drop_table :event_answer_data
  end

end
