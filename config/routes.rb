WisdomCampus::Application.routes.draw do
  root 'main_pages#home'

  resources :sessions, only: [:new, :create, :destroy]
  resources :departments, :roles, :users, :menus, :agencies, :announcements, :steps, :procedures, :projects
  resources :class_roles, :iclasses, :grades, :school_types, :behavior_types
  resources :sms, :estimate_rules, :semesters
  resources :behaviors, :students

  match '/login',  to: 'sessions#new',        via: 'get'
  match '/logout', to: 'sessions#destroy',    via: 'delete'
  match '/about',  to: 'main_pages#about',    via: 'get'
  match '/my',     to: 'main_pages#my',       via: 'get'

  match '/main_pages',        to: 'main_pages#home',               via: 'get'
  match '/change_password',   to: 'main_pages#change_password',    via: 'get'
  match '/update_password',   to: 'main_pages#update_password',    via: 'post'

  match '/read_announcement', to: 'announcements#read',            via: 'get'

  match 'handle_workflow',    to: 'announcements#handle_workflow', via: 'post'
  match 'handle_workflow',    to: 'announcements#handle_workflow', via: 'get'
  match 'handle_review',      to: 'announcements#handle_review',   via: 'get'
  match 'being_reviewed',     to: 'announcements#being_reviewed',  via: 'get'

  match '/students_home',     to: 'students#home',                 via:   'get'
  match '/students_query',    to: 'students#query',                via:   'get'
  match '/graduate',          to: 'grades#graduate',               via:   ['get', 'post']
  match '/student_graduate',  to: 'students#graduate',             via:   ['get', 'post']
  match '/behavior_print',    to: 'behaviors#print',               via:   'get'
  match '/behavior_confirm',  to: 'behaviors#confirm',             via:   'get'

  match '/reports',           to: 'reports#home',                  via: 'get'
  match '/via_classes',       to: 'reports#via_classes',           via: 'get'
  match '/via_grades',        to: 'reports#via_grades',            via: 'get'
  match '/query',             to: 'reports#query',                 via: 'get'
  match '/print_estimate',    to: 'reports#print_estimate',        via: 'get'

  match '/import_export_students', to: 'students#import_export',   via: 'get'
  match '/import_students',   to: 'students#import',               via: 'post'
  match '/export_students',   to: 'students#export',               via: 'get'

  match '/download_file',     to: 'students#download',             via: 'get'

  match '/my_school',         to: 'my_school#home',                via: 'get'
  match '/send_message',      to: 'sms#send_sm',                   via: ['get', 'post']

  match '/query_index',       to: 'query#index',                   via: 'get'
  match '/query_query',       to: 'query#query',                   via: 'get'
  match '/query_via_class',   to: 'query#query_via_class',         via: 'get'
  match '/query_via_grade',   to: 'query#query_via_grade',         via: 'get'
  match '/query_to_excel',    to: 'query#query_to_excel',          via: 'get'
  match '/query_switch',      to: 'query#switch',                  via: 'get'
end