WisdomCampus::Application.routes.draw do
  root 'main_pages#home'

  resources :sessions, only: [:new, :create, :destroy]
  resources :departments, :roles, :users, :menus, :agencies, :announcements, :steps, :procedures, :projects
  resources :class_roles, :students, :iclasses, :grades, :school_types, :behaviors, :behavior_types
  
  match '/login',  to: 'sessions#new',        via: 'get'
  match '/logout', to: 'sessions#destroy',    via: 'delete'
  match '/home',   to: 'main_pages#home',     via: 'get'
  match '/about',  to: 'main_pages#about',    via: 'get'
  match '/my',     to: 'main_pages#my',       via: 'get'

  match '/main_pages/home',   to: 'main_pages#home',               via: 'get'
  match '/change_password',   to: 'main_pages#change_password',    via: 'get'
  match '/update_password',   to: 'main_pages#update_password',    via: 'post'

  match '/read_announcement', to: 'announcements#read',            via: 'get'

  match 'handle_workflow',    to: 'announcements#handle_workflow', via: 'post'
  match 'handle_workflow',    to: 'announcements#handle_workflow', via: 'get'
  match 'handle_review',      to: 'announcements#handle_review',   via: 'get'
  match 'being_reviewed',     to: 'announcements#being_reviewed',  via: 'get'

  match '/students_home',     to: 'students#home',                 via:   'get'
  match '/students_query',    to: 'students#query',                via:   'get'
  match '/behavior_print',    to: 'behaviors#print',               via:   'get'
  match '/behavior_confirm',  to: 'behaviors#confirm',             via:   'get'

  match '/reports',           to: 'reports#home',                  via: 'get'
  match '/via_classes',       to: 'reports#via_classes',           via: 'get'
  match '/via_grades',        to: 'reports#via_grades',            via: 'get'
  match '/query',             to: 'reports#query',                 via: 'get'

end
