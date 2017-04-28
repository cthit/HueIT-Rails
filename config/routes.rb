Rails.application.routes.draw do

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
      get :lock
    end
  end

  resources :sse_update do
    collection do
    end
  end

  root 'lights#index'
  post "lights/:id/turnOff" => "lights#turnOff"
  post "lights/:id/turnOn" => "lights#turnOn"
  post "lights/:id/switchOnOff" => "lights#switchOnOff"

  get 'admin/index'
  get 'admin' => 'admin#index'

  get 'admin/lock'
  get 'lock' => 'admin#lock'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
