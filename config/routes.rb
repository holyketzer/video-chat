Rails.application.routes.draw do
  resources :chat_rooms do
    member do
      post :join
    end
  end
end
