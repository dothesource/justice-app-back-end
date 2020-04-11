Rails.application.routes.draw do
  devise_for :users
  root to: "users#index"
  resources :users

  resource :tokens, only: [:create] do
    collection do
      get 'check'
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
