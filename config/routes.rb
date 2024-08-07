Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :chatrooms, only: [:index, :show, :new, :create, :destroy] do
    resources :messages, only: :create
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resources :bookings, only: [:new, :create, :destroy]
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :users do
    member do
      get 'become_interviewer', to: 'interviewers#become_interviewer'
      patch 'upgrade_to_interviewer', to: 'interviewers#upgrade_to_interviewer'
    end
  end
  get '/users/:interviewer_id/bookings/new', to: 'bookings#new', as: 'new_interview_booking'
  post '/users/:interviewer_id/bookings/create', to: 'bookings#create', as: 'interview_booking'
  get '/mybookings', to: 'bookings#mybookings', as: 'my_bookings'
  get '/myinterviews', to: 'bookings#myinterviews', as: 'myinterviews'
  patch '/mybookings/:booking_id/update_status', to: 'bookings#update_status', as: 'update_booking_status'

  get '/auth', to: 'zoom#auth'
  get '/oauth/callback', to: 'zoom#zoom_callback'

  resources :bookings, only: [:edit, :update, :destroy] do
    resources :reviews, only: [:new, :create]
  end
  resources :reviews, only: [:edit, :update, :destroy]
end
