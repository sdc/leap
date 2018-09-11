Ilp2::Application.routes.draw do

  namespace :admin do
    resources :settings
    resources :views
    match 'test'       => 'test#index', via: [:get, :post], :as => :test
    match 'stats'      => 'stats#index', via: [:get, :post]
    match 'test/login' => 'test#login', via: [:get, :post], :as => :test_login
    # match 'sync_grade_tracks' => 'data#sync_grade_tracks'
  end
  resources :views
  resources :absences
  resources :events do
    get "more", :on => :collection
    get "open_extended", :on => :member
  end
  resources :people do
    resources :initial_reviews, :progress_reviews, controller: 'reviews'
    resources :events, :timetables
    resources :views, :only => [:show] do
      get "header", :on => :member
    end
    collection do
      get :search, :select
    end
    member do
      get :next_lesson_block, :my_courses_block, :targets_block
      get :moodle_block, :attendance_block, :poll_block
    end
  end
  resources :courses do
    resources :views do
      get "header", :on => :member
    end 
    resources :timetables
    member do
      get :next_lesson_block, :moodle_block, :reviews_block, :entry_reqs_block
      post :add
    end
    resources :plps, :only => [:show], constraint: { id: /overview|reviews|support|checklist|badges|achievement|progress/ }
  end

  get 'populate_pi_types' => 'courses#populate_pi_types'

  root :to => "people#index"
end
