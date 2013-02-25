RedmineApp::Application.routes.draw do
  match ':controller(/:action(/:id))(.:format)'
	resources :event_models
	resources :event_answer_datas
	resources :event_user_answers
end
