MainRailsServer::Application.routes.draw do

  resources :feedback, :only => [:new, :create]

  match "close_fancybox" =>  "home#close_fancybox"
  match "about_us" =>  "home#about_us"
  match "csp_report" =>  "home#csp_report"

  scope "events" do
    match "upload_bulk"  =>  "events#upload_bulk"
    match "delete"  =>  "events#delete"
    match "poll"    =>  "events#poll"
  end
  resources :events

  scope "users" do
    match "init"    =>  "users#init"
    match "check_phone_number"    =>  "users#check_phone_number"
    match "verify_password"    =>  "users#verify_password"
    match "phone/:phone_number" =>  "users#show"
  end

  resources :user_sessions
  match 'login/:width/:height' => 'user_sessions#new', :as => :login
  match 'login' => 'user_sessions#new', :as => :login
  match 'logout' => 'user_sessions#destroy', :as => :logout

  constraints :phone_number => /\d+/ do
    match ":phone_number"  => "events#calendar"
    match ":phone_number/map/:id"     => "events#map"
    match ":phone_number/new"     => "events#new"
    match ":phone_number/charts"     => "events#charts"
	match ":phone_number/timeline"     => "events#timeline"
	match ":phone_number/table"     => "events#table"
  end

  root :to => "events#calendar"

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

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
