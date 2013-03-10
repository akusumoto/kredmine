class EventModel < ActiveRecord::Base
  unloadable
  has_many :event_answer_datas, :dependent => :delete_all
  has_many :event_users, :dependent => :delete_all
	
	validates :event_subject,
		:presence => true
	validates :event_caption,
		:presence => true
		
end
