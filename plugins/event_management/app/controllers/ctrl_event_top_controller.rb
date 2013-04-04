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
		@now_order = "ASC"
		order_field = "event_subject"
		setup_now_project_events(@now_order, order_field)
		
		# このイベントの回答選択肢を列挙.
				
  end

	def sort
		@now_order = params[:now_order]
		order_field = params[:order_field]
		setup_now_project_events( @now_order, order_field )
		if @now_order == "DESC"		
			@now_order = "ASC"
		else		
			@now_order = "DESC" 
		end
	end
	
	
	def destroy
		@event = EventModel.find( params[:event] );
		@event.destroy();
		redirect_to "index", :project_id => @project
	end
	
#------------------------------------.
# 以下ユーティリティ的なもの.
#------------------------------------.
	
	
	# このプロジェクトに属する全イベントを取得する.
	def setup_now_project_events( now_order, order_field )
		begin 
			if ( order_field != nil && now_order != nil ) 
				@now_project_events = EventModel.where(:project_id => @project.id ).order( " #{order_field} #{now_order}" )
			else
				@now_project_events = EventModel.find(:all, :conditions => ["project_id = #{@project.id} "])
			end
			
			this_user_id = User.current.id
			@now_project_events.each do |ev| 
				if ( !ev.is_open_event( this_user_id ) ) 
					@now_project_events.destroy(ev)
				end
			end
			
			@now_project_events_users = Hash.new
			@now_project_events.each do |ev| 
				user = @project.principals.find(ev.event_owner_id)
				@now_project_events_users.store( ev.event_owner_id, user)
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
