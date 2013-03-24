class EventAnswerData < ActiveRecord::Base
	unloadable
	belongs_to :event_model
	
	def self.new_answer
		now_answer = EventAnswerData.new
		now_answer.on_created_time = Time.now.to_s(:db)
		return now_answer
	end
	
end
