Ilp2::Application.routes.draw do

  resources :views, :settings
  resources :events do
    get "more", :on => :collection
    get "open_extended", :on => :member
  end
  resources :people do
    resources :events, :timetables
    resources :views do
      get "header", :on => :member
    end
    get :search, :on => :collection
    member do
      get :next_lesson_block, :my_courses_block, :targets_block
      get :moodle_block, :attendance_block
    end
  end
  resources :courses do
    resources :views
    resources :timetables
    member do
      get :next_lesson_block, :moodle_block, :reviews_block
      post :add
    end
  end

  match 'test'       => 'test#index', :as => :test
  match 'stats'      => 'test#stats'
  match 'test/login' => 'test#login', :as => :test_login

  root :to => "people#index"
end
