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
  end
  resources :courses do
    resources :views
    resources :timetables
  end

  match 'test'       => 'test#index', :as => :test
  match 'stats'      => 'test#stats'
  match 'test/login' => 'test#login', :as => :test_login

  root :to => "people#index"
end
