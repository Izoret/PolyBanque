Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resource :session
  resources :passwords, param: :token
  resource :sign_up

  root "groups#index"

  resources :groups, only: [ :index, :new, :create, :show ] do
    post "quit", on: :member, action: :quit
    post "invite", on: :member, action: :invite_user

    resources :operations, only: [ :edit, :update, :new, :create, :destroy ], shallow: true
  end
end
