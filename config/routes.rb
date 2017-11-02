Rails.application.routes.draw do
  root "results#index"
  post '/results', to: "results#next"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
