Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#index'

  resources :chat_rooms do
    member do
      post :join
    end
  end
end
