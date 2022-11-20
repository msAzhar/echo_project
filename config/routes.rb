Rails.application.routes.draw do
  resources :endpoints
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  match '*path', to: 'endpoints#echo', via: :all
end
