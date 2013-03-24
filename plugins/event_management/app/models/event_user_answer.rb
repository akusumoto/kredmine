class EventUserAnswer < ActiveRecord::Base
  unloadable
	belongs_to :event_model
	
	def self.new_model( user_id, event_id )
		answer = EventUserAnswer.new
		answer.answer_user_id = user_id;
		answer.event_model_id = event_id;
		return answer
	end
end
