class CtrlEventTopController < ApplicationController
  unloadable
  menu_item :event_menu
  before_filter :find_project, :authorize


#---------------------------------------------.
# 初期表示メソッド.
#---------------------------------------------.
  def index
    # このプロジェクトに属する全イベントを取得する.
    @now_project_events = EventModel.find(:all, :conditions => ["project_id = #{@project.id} "])
  end

#---------------------------------------------.
# 新規イベント追加.
#---------------------------------------------.
  def new
  
  end

#---------------------------------------------.
# イベント破棄.
#---------------------------------------------.
  def destroy
  
  end

#---------------------------------------------.
# イベント表示.
#---------------------------------------------.
  def show
  
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
