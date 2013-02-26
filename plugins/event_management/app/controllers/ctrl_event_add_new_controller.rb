class CtrlEventAddNewController < ApplicationController
	unloadable
  menu_item :event_menu
  before_filter :find_project, :authorize, :except => []
  layout 'standard'


#---------------------------------------------.
# 初期表示メソッド.
#---------------------------------------------.
  def index
		redirect_to :action => 'new', :project_id => @project
	 #render "new", :project_id => @project
  end
  
#---------------------------------------------.
# 生成メソッド.
#---------------------------------------------.
  def new
		@event = params[:event]
		# 生成処理.
    if @event.blank? then
			 puts( "new!!!!" )
       @yes = self.class.helpers.createAnswer_YES()
       @no = self.class.helpers.createAnswer_NO()
       @event = EventModel.new(params[:event])
       @event.project_id = @project.id
       @event.event_answer_datas << @yes
       @event.event_answer_datas << @no
       @event.event_owner_id = User.current.id
		end
     
	  # このプロジェクトに属する全ユーザを列挙.
    # グループごとに別リストに詰める.
    if @now_project_group_list.blank? then
        @now_project_group_list = GroupUserList.new
        @now_project_group_list.setup( @project )
    end
   	
		render 'new'
  end

#---------------------------------------------.
# データ編集画面.
#---------------------------------------------.
  def edit
  end
 
  
#---------------------------------------------.
# データ追加メソッド.
#---------------------------------------------.
  def add
    #@event = params[:event]
	  if request.post? and @event.save
        @yes.save  
        @no.save
        flash[:notice] = l(:notice_successful_create)
        redirect_to :action => 'show', :project_id => @project, :event => @event
    end
  end

	
#---------------------------------------------.
# 回答データ一件削除.
#---------------------------------------------.
  def delete_answer
		@event = params[:event]
		now_delete_answer = params[:now_delete_answer]
		@event.event_answer_datas.delete(now_delete_answer)
    now_delete_answer.destroy
    flash[:notice] = l(:label_destroy_answer)
		
  # redirect_to :action => 'new', :project_id => @project, :event => @event
	#	render :action => "new", :event => @event, :project_id => @project
  end

  
#---------------------------------------------.
# 回答データ一件追加.
#---------------------------------------------.
  def add_answer
    
  end



   class GroupUser
    def setup( group_id, name )
      @group = group_id
      @users = Array.new
      @name = name
    end
    
    def add( user )
      @users << user
    end
    
    def get_group
      return @group
    end
    
    def get_users 
      return @users
    end
    
    def name
      return @name
    end
    
   end
  
  class GroupUserList
    
     def setup( project )
      @users = Hash.new
      @group_users = Array.new
      group_users_check = Hash.new
      @now_users =  Project.find(project.id).principals.find(:all)
      @now_users.each do |itr|
        if !@users.key(itr.id) then
          @users.store( itr.id, itr )
          # グループに属していない場合は non group userとして登録.
          if itr.groups.empty? then
            if group_users_check.key?( -1 ) then
              now_gu =group_users_check[ -1 ]
            else
              now_gu = GroupUser.new
              now_gu.setup( -1, "未割当グループ" )
              group_users_check.store( -1, now_gu )
              @group_users << now_gu
            end
          # 属している場合は普通に登録.
          else 
            itr.groups.each do |group|
              if group_users_check.key?( group.id ) then
                now_gu = group_users_check[ group.id ]
              else
                now_gu = GroupUser.new
                now_gu.setup( group.id, group.name )
                group_users_check.store( group.id, now_gu )
                @group_users << now_gu
              end
            end
          end
          now_gu.add( itr )
        end
      end
    end
    
    def get_nongroup_users
      return @non_group_users
    end
    
    def get_group_users
      return @group_users
    end
    
    def get_users
      return @users
    end
    
  end
  
#---------------------------------------------.
# プレビュー.
#---------------------------------------------.
  def preview
    @text = params[:event][:event_caption]
    render :partial => 'common/preview'
  end
  
private
  def find_project
    @project = Project.find(params[:project_id])
    rescue ActiveRecord::RecordNotFound
      render_404
  end
end
