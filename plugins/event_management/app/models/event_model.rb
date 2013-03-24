class EventModel < ActiveRecord::Base
  unloadable
	# 定義周り.
  has_many :event_answer_datas, :dependent => :delete_all
  has_many :event_users, :dependent => :delete_all
	has_many :event_user_answers, :dependent => :delete_all
	
	# 入力チェック周り.
	validates :event_subject,
		:presence => true
	validates :event_caption,
		:presence => true
	validates :project_id,
		:presence => true
	validates :event_owner_id,
		:presence => true
	validates :event_date,
		:presence => true
	validates :event_place_station,
		:presence => true
	validates :event_place,
		:presence => true
	validates_length_of :event_answer_datas,
		 :minimum => 1
	validates_length_of :event_users,
		 :minimum => 1
	
	
	#----------------------------------.
	# 以下サポートメソッド的な.
	#----------------------------------.
	
	# このイベントにこのユーザーが含まれているか？.
	def is_event_in_user( user_id )
		ret = false
		now_check_user_id = user_id.to_i
		event_users.each do |itr|
			if itr.user_id == now_check_user_id 
				return true
			end
		end
#		return event_users.exists?( :user_id => now_check_user_id )
		return false
	end
	
	
	# このイベントはこのユーザーに開放されているか？.
	def is_open_event( user_id )
		# @note あとで公開設定まわり作るときはこの関数をいじろう.
		return is_event_in_user( user_id )
	end
	
end
