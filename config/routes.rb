Pinteresting::Application.routes.draw do
  resources :eavesdrops

  resources :microposts

  resources :pins

  #resources :widgets

  #map.connect '/widgets/:action/:api_key', :controller => 'widgets', :api_key => /.*/
  #map.connect '/widgets/:action', :controller => 'widgets', :action => 'ilove'
  #map.connect '/widgets', :controller => 'widgets'
  #map.connect '/widgets', :controller => 'widgets', :action => 'show'

  #line below was written when I though I needed to add a custom registrations. but I updated Application controller instead and it works
  #devise_for :users, :controllers => { :registrations => "users/registrations" }
  devise_for :users
  resources :users do
  member do
      get :whoresponders, :whoinitiators, :conversations
    end
  end

  # do
  #member do
  #    get :whoresponders, :whoinitiators
  #  end
  #end
  #get 'users/:id' => 'users#show'

  #resources :sessions, only: [:new, :create, :destroy]
  # => resources :microposts,    only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]


  root "microposts#index"
  get "about" => "pages#about"
  get "conversations" => "pins#index"
  get "widgets" => "widgets#ilove"
  get "users_consulting" => "users#consulting_index"
  get "users_gradapplication" => "users#gradapplication_index"
  get "pins_consulting" => "pins#consulting_index"
  get "pins_gradapplication" => "pins#gradapplication_index"

  #get "users/:id/whoresponders" => "microposts#index"
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
