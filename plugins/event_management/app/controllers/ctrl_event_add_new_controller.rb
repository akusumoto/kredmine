# encoding: utf-8
class CtrlEventAddNewController < ApplicationController
	require_relative "../helpers/ctrl_util_helper.rb"
	#include UtilHelper
	
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
		end
	#	session[:event] = @event
		$g_event = @event
		
	  # このプロジェクトに属する全ユーザを列挙.
    # グループごとに別リストに詰める.
    @now_project_group_list = create_user_datas_new( @project, @event );
  end

#---------------------------------------------.
# データ編集画面.
#---------------------------------------------.
  def edit
		$g_event = EventModel.find( params[:event] )
		redirect_to :action => 'new', :project_id => @project
	end

#---------------------------------------------.
# データコピーして新規.
#---------------------------------------------.
  def copy
		$g_event = EventModel.new( EventModel.find(params[:event]) )
		redirect_to :action => 'new', :project_id => @project
	end

  
#---------------------------------------------.
# データ追加メソッド.
#---------------------------------------------.
  def add
		# 戻ってきたハッシュデータを元にイベント再構築.
		form_data = params[:event_model]
		@event = EventModel.new( form_data )
		@event.project_id = @project.id
    @event.event_owner_id = User.current.id
		@event.updated_on = Time.now.to_datetime
		@event.created_on = @event.updated_on
		
		# 回答情報セットアップ.
		# @note もうこれでいいや...
		event_subjects = params[:answer_subjects]
		if ( event_subjects != nil )
			event_subjects.each do |itr|
				@event.event_answer_datas << EventAnswerData.new_answer(itr)
			end
		end
		
		# 回答者セットアップ.
		event_check_user_ids = params[:event_check_user_ids]
		if ( event_check_user_ids != nil )
			if event_check_user_ids != nil 
				event_check_user_ids.each do |itr|
					@event.event_users << EventUser.new_user(itr)
				end
			end
		end
		@event.event_users << EventUser.new_user(User.current.id)
		
		# セーブが成功したかチェック.
		#is_success = ( request.post? and form_answers.length > 0 and @event.save )
		is_success = ( request.post? && @event.save )
		if is_success
				# 成功したらそのまま詳細画面に飛ばす.
			  $g_event = nil
				flash[:notice] = l(:notice_successful_create)
				redirect_to :controller  => "ctrl_event_detail", :action => "show", :project_id => @project, :event => @event
		# セーブが失敗していればエラーメッセージ描画.
		else
				# 再リクエストで情報が吹っ飛んでしまうので再セットアップ.
				$g_event = @event
		  	@now_project_group_list = create_user_datas_new( @project, @event );

				
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
  end

	
#---------------------------------------------.
# 回答データ一件削除.
#---------------------------------------------.
  def delete_answer
		#@event = session[:event]
		@event = $g_event
		@now_delete_ans_createdtime = params[:now_delete_answer_created_time]
		now_delete_answer = nil
		@event.event_answer_datas.each do |itr|
			if itr.on_created_time == @now_delete_ans_createdtime
				now_delete_answer = itr;
				break;
			end
		end
	#	now_delete_answer = @event.event_answer_datas.find( :conditions => [ "on_created_time == #{@now_delete_ans_createdtime}" ] )
		if now_delete_answer != nil 
			@event.event_answer_datas.delete(now_delete_answer)
		end
		
		@now_project_group_list = create_user_datas_new( @project, @event );
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
	
	
	def create_user_datas_new(project, event)
		list = create_user_datas(project, event)
		list.get_group_users.each do |group|
			group.get_users.each do |itr|
				if ( itr.user.id == User.current.id )
					group.get_users.delete( itr )
					return list;
				end
			end
		end
		return list;
	end
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
#---------------------------------------------.
# 以下ヘルパー移動予定.
#---------------------------------------------.
	
	
	
#---------------------------------.
# 関数達.
#---------------------------------.
	def create_user_datas( project, event )
		list = EventGroupList.new
		list.setup( project, event )
		return list;
	end



#---------------------------------.
# ユーザー.
#---------------------------------.
	class EventGroupUser
		def setup( user_a, is_check_a )
			@user = user_a
			@is_check = is_check_a
		end
		
		def is_check
			return @is_check
		end
		
		def user
			return @user
		end
		
		def set_answer( user_answer, answer_data )
			@user_answer = user_answer
			@answer_data = answer_data
		end
		
		def get_user_answer
			return @user_answer
		end

		def get_answer_data
			return @answer_data
		end
		
	end
	
#---------------------------------.
# イベントグループ.
#---------------------------------.
  class EventGroup
    def setup( group_id, name )
      @group = group_id
      @users = Array.new
      @name = name
    end
    
    def add( user, is_check )
			new_user = EventGroupUser.new 
			new_user.setup( user, is_check )
			@users << new_user
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
  
#---------------------------------.
# イベントグループリスト.
#---------------------------------.
  class EventGroupList
    
     def setup( project, event )
			@users = Hash.new
      @group_users = Array.new
      group_users_check = Hash.new
      @now_users = Project.find(project.id).principals.find(:all)
      @now_users.each do |itr|
				if itr.type != "User"
					next;
				end
				
				if !@users.key(itr.id) then
          @users.store( itr.id, itr )
          # グループに属していない場合は non group userとして登録.
          if itr.groups.empty? then
            if group_users_check.key?( -1 ) then
              now_gu =group_users_check[ -1 ]
            else
              now_gu = EventGroup.new
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
                now_gu = EventGroup.new
                now_gu.setup( group.id, group.name )
                group_users_check.store( group.id, now_gu )
                @group_users << now_gu
              end
            end
          end
          now_gu.add( itr, event.is_event_in_user(itr.id) )
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
end
