RailsApp::Application.routes.draw do

  get "administration/index"
  get "administration/players"
  get "administration/assignments"
  get "welcome/index"
  get "welcome/handbook"
  get "welcome/central"
  post "rounds/start" 
 
  match "rounds/current" => "rounds#current"
  match "rounds/current/end" => "rounds#end_current"
  match "welcome/about" => "welcome#about"
  match "administration" => "administration#index"
  match "players/login" => "players#login"
  match "players/logout" => "players#logout"
  match "players/change_password" => "players#change_password"
  match "players/index" => "players#index"
  match "confirm/:confirmation_code" => "players#confirm"
  match "players/:id/confirmation" => "players#confirmation"

  resources :rounds
  resources :players
  resources :sessions
  resources :assignments

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
   root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
