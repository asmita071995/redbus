Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
    get 'homes/index'
    get 'homes/contact'
  
    root "sessions#new"

    resources :users do
      resources :bookings
    end
    

    resources :bookings do
      member do
        get 'download_invoice'
      end
    end
  
  resources :cities do
    resources :locations
  end
  
  resources :locations
  resources :buses
  resources :dashboard
  resources :homes
  resources :transactions
  
  resources :sessions do
    delete "/logout", to: 'sessions#destroy'
  end

  resources :bookings
    resources :bus_routes do
       resources :buses
    end
  
  get '/login', to: 'sessions#login'
  post '/login', to: 'sessions#create', as: "user_login"
  get '/confirm', to: 'bookings#confirm'
  get '/cancel', to: 'bookings#cancel'
  get '/refund', to: 'bookings#refund'
  # Defines the root path route ("/")
  # root "articles#index"
end
