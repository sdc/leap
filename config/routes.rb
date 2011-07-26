Ilp2::Application.routes.draw do

    resources :views
  resources :notes
  resources :targets
  resources :timetables
  resources :contact_logs
  resources :review_lines
  resources :events do
    collection do
      get :more
    end
    member do
      get :open_extended
    end
    resources :targets
  end
  resources :people do
    resources :events
    resources :timetables
    resources :views
    collection do
      get :search
    end
  end
  resources :courses do
    resources :views
  end

  match 'test'       => 'test#index', :as => :test
  match 'stats'      => 'test#stats'
  match 'test/login' => 'test#login', :as => :test_login

  root :to => "people#index"
end
