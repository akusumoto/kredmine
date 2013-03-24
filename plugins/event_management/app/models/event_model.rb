class EventModel < ActiveRecord::Base
  unloadable
  has_many :event_answer_datas, :dependent => :destroy
  has_many :event_users, :dependent => :destroy
	
	validates :event_subject,
		:presence => true
	validates :event_caption,
		:presence => true
	
	def is_event_in_user( user )
		ret = false
		now_check_user_id = user.id.to_i
		event_users.each do |itr|
			if itr.user_id == now_check_user_id 
				return true
			end
		end
#		return event_users.exists?( :user_id => now_check_user_id )
		return false
	end
	
end
