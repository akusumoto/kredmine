class CreateEventsAnswersTables < ActiveRecord::Migration
  def change
    create_table :events_answers_tables do |t|
      t.integer :event_model_id
      t.integer :event_answer_data_id
    end

  end
end
