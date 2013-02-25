RedmineApp::Application.routes.draw do
 # match 'projects/:id/ctrl_event_top/:action', :controller => 'ctrl_event_top', :via => [:index, :new, :show, :destroy]
 # match 'projects/:id/ctrl_event_setting/:action', :controller => 'ctrl_event_setting', :via => [:index]
 # match 'projects/:id/ctrl_event_detail/:action', :controller => 'ctrl_event_detail', :via => [:index]
 # match 'projects/:id/ctrl_event_add_new/:action', :controller => 'ctrl_event_add_new', :via => [:index]
  match ':controller(/:action(/:id))(.:format)'
end
