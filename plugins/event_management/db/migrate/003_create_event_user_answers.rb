class CreateEventUserAnswers < ActiveRecord::Migration
  def self.up
    create_table :event_user_answers do |t|
      t.column :event_model_id, :integer
			t.column :event_answer_data_id, :integer
      t.column :answer_user_id, :integer
      t.column :comment, :string
    end
  end

  def self.down
    drop_table :event_user_answers
  end
end
