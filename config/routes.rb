Rails.application.routes.draw do
  root to: 'pages#index'

  resources :chat_rooms do
    member do
      post :join
    end
  end
end
