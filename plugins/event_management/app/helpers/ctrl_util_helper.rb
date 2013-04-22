# encoding: utf-8
module UtilHelper

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
