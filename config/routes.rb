Ilp2::Application.routes.draw do
  namespace :admin do
    resources :settings
    get 'test'       => 'test#index', :as => :test
    #get 'stats'      => 'stats#index'
    get 'sync_grade_tracks' => 'data#sync_grade_tracks'
    match 'test/login' => 'test#login', :as => :test_login, :via => [:get, :post]
  end
  resources :timeline_views, only: :index
  resources :events
  resources :people do
    resources :events
    resources :timeline_views, only: [:show,:index]
    collection do
      get :search, :select
    end
  end
  resources :courses do
    resources :events
    resources :timeline_views
  end
  root to: "people#index"
end
