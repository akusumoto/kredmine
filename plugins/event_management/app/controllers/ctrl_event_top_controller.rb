# encoding: utf-8
class CtrlEventTopController < ApplicationController
  unloadable
  menu_item :event_menu
  before_filter :find_project, :authorize


#---------------------------------------------.
# 初期表示メソッド.
#---------------------------------------------.
  def index
		session[:event] = nil
    # このプロジェクトに属する全イベントを取得する.
		#@now_order = "ASC"
		#order_field = "event_subject"
		@now_user = User.current
		@now_order = "DESC"
		order_field = "event_date"
		setup_now_project_events(@now_order, order_field)
		setup_past_project_events(@now_order, order_field)
		if @now_user.admin?
			setup_other_project_events(@now_order, order_field)
		end

		# for link of 'イベント日' on the view
		@now_order = "ASC"
  end

	def sort
		@now_order = params[:now_order]
		order_field = params[:order_field]
		@now_user = User.current
		
		if order_field == "event_answer_state" || order_field == "event_answer_count"
			setup_past_project_events( @now_order, nil )
			setup_now_project_events( @now_order, nil )
			if @now_user.admin?
				setup_other_project_events( @now_order, nil )
			end
			
			if order_field == "event_answer_state"
					@now_project_events.sort!{ |a,b|
						a_ans = 0
						b_ans = 0
						if a.is_answer_your( @now_user.id ) 
							a_ans = a.get_user_answer( @now_user.id ).event_answer_data_id;	
						end
						if b.is_answer_your( @now_user.id )
							b_ans = b.get_user_answer( @now_user.id ).event_answer_data_id;
						end
						if ( @now_order == "DESC" ) 
							a_ans <=> b_ans 
						else
							b_ans <=> a_ans 
						end
					}
					@past_project_events.sort!{ |a,b|
						a_ans = 0
						b_ans = 0
						if a.is_answer_your( @now_user.id ) 
							a_ans = a.get_user_answer( @now_user.id ).event_answer_data_id;	
						end
						if b.is_answer_your( @now_user.id )
							b_ans = b.get_user_answer( @now_user.id ).event_answer_data_id;
						end
						if ( @now_order == "DESC" ) 
							a_ans <=> b_ans 
						else
							b_ans <=> a_ans 
						end
					}
			end
		else 
			setup_past_project_events( @now_order, order_field )
			setup_now_project_events( @now_order, order_field )
			if @now_user.admin?
				setup_other_project_events( @now_order, order_field )
			end
		end
		
		# for link of 'イベント日' on the view
		if @now_order == "DESC"		
			@now_order = "ASC"
		else		
			@now_order = "DESC" 
		end
	end
	
	
	def destroy
		@event = EventModel.find( params[:event] );
		@event.destroy();
		redirect_to :action => 'index', :project_id => @project
	  rescue ActiveRecord::RecordNotFound
			redirect_to :action => 'index', :project_id => @project
	end
	
#------------------------------------.
# 以下ユーティリティ的なもの.
#------------------------------------.
	# このプロジェクトに属する今後（当日を含む）のイベントを取得する.
	def setup_now_project_events( now_order, order_field )
		begin 
			if ( order_field != nil && now_order != nil ) 
				@now_project_events = EventModel.joins(:event_users).
					where("event_date >= ?", Time.now.midnight).
                    where(:project_id => @project.id,
                          'event_users.user_id' => User.current.id).
					order( " #{order_field} #{now_order}" ).uniq
			else
                @now_project_events = EventModel.joins(:event_users).
					where("event_date >= ?", Time.now.midnight).
                	where(:project_id => @project.id,
                          'event_users.user_id' => User.current.id).
					order(:event_date).uniq
			end
			this_user_id = User.current.id
			
			@now_project_events_users = Hash.new
			@now_project_events_users.store( this_user_id, User.current )
			@now_project_events.each do |ev| 
				begin
					user = @project.principals.find(ev.event_owner_id)
					@now_project_events_users.store( ev.event_owner_id, user)
				rescue => e
					p e.message
				end
			end
		rescue ActiveRecord::RecordNotFound
		end
	end
  
	# このプロジェクトに属する過去（昨日以前）のイベントを取得する.
	def setup_past_project_events( now_order, order_field )
		begin 
			# イベントを更新するたびに event_users が作られるバグあり
			# event_users のレコードが重複してしまうため、
			# しかたなく DISTINCT (uniq) している
			@past_event_count = EventModel.joins(:event_users).
					where("event_date < ?", Time.now.midnight).
                    where(:project_id => @project.id, 'event_users.user_id' => User.current.id).
					count('DISTINCT event_models.id, event_users.user_id')
			@limit = per_page_option
			@past_event_pages = Paginator.new self, @past_event_count, @limit, params['page']
			@offset ||= @past_event_pages.current.offset

			if ( order_field != nil && now_order != nil ) 
				@past_project_events = EventModel.joins(:event_users).
					where("event_date < ?", Time.now.midnight).
                    where(:project_id => @project.id, 'event_users.user_id' => User.current.id).
					order( " #{order_field} #{now_order}" ).
					offset(@offset).
					limit(@limit).
					uniq
			else
                @past_project_events = EventModel.joins(:event_users).
					where("event_date < ?", Time.now.midnight).
                	where(:project_id => @project.id, 'event_users.user_id' => User.current.id).
					order(:event_date).
					offset(@offset).
					limit(@limit).
					uniq
			end
			this_user_id = User.current.id
			
			@past_project_events_users = Hash.new
			@past_project_events_users.store( this_user_id, User.current )
			@past_project_events.each do |ev| 
				begin
					user = @project.principals.find(ev.event_owner_id)
					@past_project_events_users.store( ev.event_owner_id, user)
				rescue => e
					p e.message
				end
			end
		rescue ActiveRecord::RecordNotFound
		end
	end

	# このプロジェクトに属する今後（当日を含む）のイベントで自分が属さないものを取得する（管理者確認用）
	def setup_other_project_events( now_order, order_field )
		begin 
			this_user_id = User.current.id
			event_model_ids = EventUser.select(:event_model_id).where(:user_id => this_user_id)
			if ( order_field != nil && now_order != nil ) 
				@other_project_events = EventModel.where("id NOT IN (#{event_model_ids.to_sql})").
					where("event_date >= ?", Time.now.midnight).
                    where(:project_id => @project.id).
					order( " #{order_field} #{now_order}" ).uniq
			else
				@other_project_events = EventModel.where("id NOT IN (#{event_model_ids.to_sql})").
					where("event_date >= ?", Time.now.midnight).
                	where(:project_id => @project.id).
					order(:event_date).uniq
			end
			
			@other_project_events_users = Hash.new
			@other_project_events_users.store( this_user_id, User.current )
			@other_project_events.each do |ev| 
				begin
					user = @project.principals.find(ev.event_owner_id)
					@other_project_events_users.store( ev.event_owner_id, user)
				rescue => e
					p e.message
				end
			end
		rescue ActiveRecord::RecordNotFound
		end
	end
  
	def clear_data_all
		#EventAnswerTable.destroy_all
		EventModel.destroy_all
		EventAnswerData.destroy_all
		EventUserAnswer.destroy_all
		redirect_to :action => "index", :project_id => @project
	end
  
#---------------------------------------------.
#---------------------------------------------.
#---------------------------------------------.
#---------------------------------------------.
private
#---------------------------------------------.
# このプロジェクトの属する事を表す？.
#---------------------------------------------.
  def find_project
    @project = Project.find(params[:project_id])
    rescue ActiveRecord::RecordNotFound
      render_404
  end
end
