class CtrlEventDetailController < ApplicationController
  unloadable
  menu_item :event_menu
  before_filter :find_project, :authorize
  layout 'standard'

	
	def show
		@event = EventModel.find( params[:event] )
		@event_owner = User.find(@event.event_owner_id)
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
