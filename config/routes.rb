Ilp2::Application.routes.draw do
  resources :notes
  resources :targets
  resources :timetables
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
<<<<<<< HEAD
    resources :timetables
=======
    collection do
      get :search
    end
>>>>>>> search
  end

  match 'test'       => 'test#index', :as => :test
  match 'test/login' => 'test#login', :as => :test_login

  root :to => "test#index"
end
