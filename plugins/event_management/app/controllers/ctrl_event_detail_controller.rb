class CtrlEventDetailController < ApplicationController
	unloadable
  menu_item :event_menu
  before_filter :find_project, :authorize, :except => []
  layout 'standard'

	# 表示処理.
	def show
		@event = EventModel.find( params[:event] )
		@event_owner = User.find(@event.event_owner_id)
		get_this_user_answer();
		
	end

	# 回答情報送信.
	def answer
		@event = EventModel.find( params[:event] )
		@event_owner = User.find(@event.event_owner_id)
	
		get_this_user_answer();
		form_data = params[:event_user_answer]
		puts(form_data)
		if ( @event_this_answer.update_attributes!( form_data ) )
#			puts( @event_this_answer.comment )
		else
#			puts( "failed update" )
#			puts( @event_this_answer.comment )
			render :action => "show", :project_id => @project, :event => @event
		end
		
	end
	
#---------------------------------------------.
#---------------------------------------------.
#---------------------------------------------.
#---------------------------------------------.
private
#---------------------------------------------.
# このユーザーとイベントに関連した回答情報を取得.
#---------------------------------------------.
	def get_this_user_answer
		begin 
			@event_this_answer = EventUserAnswer.where( "answer_user_id = ? AND event_model_id = ?", User.current.id, @event.id )[0]
			if @event_this_answer == nil 
	#			puts( "nil" )
				@event_this_answer = EventUserAnswer.new_model( User.current.id, @event.id )
			else
	#			puts( "exist")
			end
		rescue ActiveRecord::RecordNotFound
	#		puts( "not found" )
			@event_this_answer = EventUserAnswer.new_model( User.current.id, @event.id )
			@event.event_user_answers << @event_this_answer
			@event.save
		end
	end
	
	
#---------------------------------------------.
# このプロジェクトの属する事を表す？.
#---------------------------------------------.
  def find_project
		begin
	    @project = Project.find(params[:project_id])
    rescue ActiveRecord::RecordNotFound
			render_404
		end
  end
	
	
end
