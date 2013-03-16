# encoding: utf-8
class CtrlEventAddNewController < ApplicationController
	unloadable
  menu_item :event_menu
  before_filter :find_project, :authorize, :except => []
  layout 'standard'


#---------------------------------------------.
# 初期表示メソッド.
#---------------------------------------------.
  def index
	#	session[:event] = nil
		$g_event = nil
		redirect_to :action => 'new', :project_id => @project
	 #render "new", :project_id => @project
  end
  
#---------------------------------------------.
# 生成メソッド.
#---------------------------------------------.
  def new
		#@event = session[:event]
		@event = $g_event
		# 生成処理.
    if @event.blank? then
			 puts( "new!!!!" )
			 # デフォ回答を生成.
       @event = EventModel.new(params[:event])
			 @yes = self.class.helpers.createAnswer_YES()
			 @no = self.class.helpers.createAnswer_NO()
       @event.event_answer_datas << @yes
       @event.event_answer_datas << @no
			 # @note 
			 # どうもセーブしないとidが振られない？ようで、delete_answerの時にidによるfindでこけてしまう模様.
			 # 何かid以外にfindの方法があればいいんだが...ひとまずsaveは残しておく.
			 @yes.save
			 @no.save
		end
	#	session[:event] = @event
		$g_event = @event
		
	  # このプロジェクトに属する全ユーザを列挙.
    # グループごとに別リストに詰める.
    if @now_project_group_list.blank? then
        @now_project_group_list = GroupUserList.new
        @now_project_group_list.setup( @project )
    end
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
		# 戻ってきたハッシュデータを元にイベント再構築.
		@event = EventModel.new( params[:event_model] )
		@event.project_id = @project.id
    @event.event_owner_id = User.current.id
		@event.updated_on = Time.now.to_datetime
		@event.created_on = @event.updated_on

		# セーブが成功したかチェック.
		if request.post? and @event.save
				# 成功したらそのまま詳細画面に飛ばす.
			  $g_event = nil
				flash[:notice] = l(:notice_successful_create)
				redirect_to :controller  => "ctrl_event_detail", :action => "show", :project_id => @project, :event => @event
		# セーブが失敗していればエラーメッセージ描画.
		else
				# 再リクエストで情報が吹っ飛んでしまうので再セットアップ.
				$g_event = @event
				@now_project_group_list = GroupUserList.new
        @now_project_group_list.setup( @project )
				
				render :action => "new", :project_id => @project, :event => @event
		end
  end

	
	  
#---------------------------------------------.
# 回答データ一件追加.
#---------------------------------------------.
  def add_answer
	#	@event = session[:event]
		@event = $g_event
		new_answer = self.class.helpers.createAnswer_Empty()
		@event.event_answer_datas << new_answer
		
		# @note 
		# どうもセーブしないとidが振られない？ようで、delete_answerの時にidによるfindでこけてしまう模様.
		# 何かid以外にfindの方法があればいいんだが...ひとまずsaveは残しておく.
		new_answer.save
    
		flash[:notice] = l(:label_add_answer)
	#	redirect_to :action => 'new', :project_id => @project, :event => @event
		#redirect_to :action => 'new', :project_id => @project, :event => @event
  end

	
#---------------------------------------------.
# 回答データ一件削除.
#---------------------------------------------.
  def delete_answer
		#@event = session[:event]
		@event = $g_event
		@now_delete_ans_id = params[:now_delete_answer]
		now_delete_answer = @event.event_answer_datas.find( :all, :conditions => ["id = #{@now_delete_ans_id}"] )
		@event.event_answer_datas.delete(now_delete_answer)
   # now_delete_answer.destroy()
		@now_project_group_list = GroupUserList.new
    @now_project_group_list.setup( @project )
		
    flash[:notice] = l(:label_destroy_answer)
  #  redirect_to :action => 'new', :project_id => @project, :event => @event
	#  render :action => 'new', :project_id => @project, :event => @event
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
