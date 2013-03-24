require 'redmine'

Redmine::Plugin.register :event_management do
  name 'Event Management plugin'
  author 'ituki_yu'
  description 'Event management utilities'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://itukiyou.dousetsu.com/'
  
  
  project_module :event_management do
    permission :view, 
               :caption => :label_event_rollsettings_view,
               :ctrl_event_top => [:index, :sort, :clear_data_all ], 
               :ctrl_event_detail => [:index, :show],
               :ctrl_event_add_new => [:index, :show]
    
    permission :manage, 
               :caption => :label_event_rollsettings_manage, 
               :ctrl_event_top => [:new, :destroy], 
               :ctrl_event_detail => [:new, :destroy],
               :ctrl_event_add_new => [:new, :destroy, :delete_answer, :add_answer, :add, :edit ],
               :require => :member
  end


  menu :project_menu, 
       :event_menu, 
       { :controller => 'ctrl_event_top', :action => 'index' },
       :param => :project_id,
       :caption => :label_event_tab_name
end
