Ilp2::Application.routes.draw do
  namespace :admin do
    resources :settings
    resources :views
    get 'test'       => 'test#index', :as => :test
    get 'stats'      => 'stats#index'
    get 'sync_grade_tracks' => 'data#sync_grade_tracks'
    match 'test/login' => 'test#login', :as => :test_login, :via => [:get, :post]
  end
  resources :views
  resources :events do
    get "more", on: :collection
    get "open_extended", on: :member
  end
  resources :people do
    resources :events, :timetables
    resources :views, only: [:show,:index] do
      get "header", on: :member
    end
    collection do
      get :search, :select
    end
    member do
      get :next_lesson_block, :my_courses_block, :targets_block
      get :moodle_courses, :attendance_block, :poll_block
    end
  end
  resources :courses do
    resources :views do
      get "header", on: :member
    end 
    resources :timetables
    member do
      get :next_lesson_block, :moodle_block, :reviews_block, :entry_reqs_block
      post :add
    end
  end
  root to: "people#index"
end
