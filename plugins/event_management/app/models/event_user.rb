class EventUser < ActiveRecord::Base
  unloadable
  belongs_to :event_model
	
	def self.new_user( id )
		new_user = EventUser.new
		new_user.user_id = id
		return new_user
	end
	
	
end
