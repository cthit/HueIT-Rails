Rails.application.routes.draw do

  resources :preset_colors
  resources :lights do
    collection do
      post :multi_update
      post :reset_lights
      post :turn_all_on
      post :turn_all_off
      post :party_on_off
    end
  end

  resources :admin do
    collection do
      post :lock
    end
  end

  resources :sse_update do
    collection do
    end
  end

  post "lights/:id/turn_off" => "lights#turn_off"
  post "lights/:id/turn_on" => "lights#turn_on"
  post "lights/:id/switch_on_off" => "lights#switch_on_off"

  post 'lock' => 'admin#lock'

  get "/auth/account", as: :signin
  match 'auth/:provider/callback' => 'sessions#create', via: [:get, :post]
  get 'signout' => 'sessions#destroy', as: :signout

  root 'lights#index'
end
