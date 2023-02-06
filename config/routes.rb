Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get "/coba/:id", to: "coba#show"
  get "/coba", to: "coba#index"
  get "/:name", to: "coba#aneh"
  
  namespace :api do
    namespace :v1 do
      resources :chats
    end
  end
end
