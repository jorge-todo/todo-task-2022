Rails.application.routes.draw do
  resources :items
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "items#index"

  namespace :api do
    namespace :v1 do
      get "/tasks",  controller: "items", action: "index"
      get "task", controller: "items", action: "show"
      post "new-task", controller: "items", action: "create"
      post "task", controller: "items", action: "update"
    end
  end
end
