class EventModel < ActiveRecord::Base
  unloadable
	# 定義周り.
  belongs_to :project
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
	# 添付ファイルを使用するためのもの.
	#----------------------------------.
	#acts_as_attachable :delete_permission => :manage_event_models
	 acts_as_attachable ({
    :dependent => :destroy,
		:view_permission => :view,
		:delete_permission => :manage
  })
	def project
    Project.find(:first, :conditions => "projects.id = #{project_id}")
  end
	
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
	
	
	# このイベントの現在回答数取得.
	def get_event_answercount_now
		return event_user_answers.count
	end
	
	# このイベントの最大回答数取得.
	def get_event_answercount_max
		return event_users.count
	end
	
	
	# このユーザーが回答しているか否か.
	def is_answer_your( user_id )
		return event_user_answers.exists?( :answer_user_id => user_id )
	end
	
	# このユーザーの回答を取得.
	def get_user_answer( user_id )
		return event_user_answers.find( :first, :conditions => ["answer_user_id = ?", user_id] )
	end
	
	# このユーザーの回答となる回答元データを取得.
	def get_answerdata_of_user( user_id )
		ans = get_user_answer( user_id )
		if ans == nil 
			return nil;
		end
		return event_answer_datas.find( :first, :conditions => ["id = ?", ans.event_answer_data_id ] )
	end
	
	
end
