Ilp2::Application.routes.draw do

  resources :views
  resources :settings
  resources :timetables
  resources :events do
    collection do
      get :more
    end
    member do
      get :open_extended
    end
  end
  resources :people do
    resources :events
    resources :timetables
    resources :views
    resources :review_lines
    collection do
      get :search
    end
    member do
      get :next_lesson_block
      get :my_courses_block
      get :targets_block
      get :moodle_block
      get :attendance_block
    end
  end
  resources :courses do
    resources :views
    resources :timetables
    member do
      get :next_lesson_block
      get :moodle_block
      post :add
    end
  end

  match 'test'       => 'test#index', :as => :test
  match 'stats'      => 'test#stats'
  match 'test/login' => 'test#login', :as => :test_login

  root :to => "people#index"
end
