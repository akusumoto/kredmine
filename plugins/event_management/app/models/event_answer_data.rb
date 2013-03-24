class EventAnswerData < ActiveRecord::Base
	unloadable
	belongs_to :event_model
	
	def self.new_answer( subject )
		now_answer = EventAnswerData.new
		now_answer.on_created_time = Time.now.to_s(:rfc822) + Time.now.usec.to_s
		now_answer.answer_subject = subject
		return now_answer
	end
	
end
