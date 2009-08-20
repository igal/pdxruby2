ActionController::Routing::Routes.draw do |map|
  #===[ Routes ]==========================================================
  # The "/*/show/:id" and "/*/list" routes are for backwards compatibility
  
  # Backwards compatible with old site
  map.connect '/pdx.rb.ics',  :controller => 'events', :action => 'index', :format => 'ics'
  map.connect '/events/ical', :controller => 'events', :action => 'index', :format => 'ics'

  map.connect '/members/show/:id', :controller => 'members', :action => 'show'
  map.connect '/members/list',     :controller => 'members', :action => 'index'
  map.resources :members

  map.connect '/locations/show/:id', :controller => 'locations', :action => 'show'
  map.connect '/locations/list',     :controller => 'locations', :action => 'index'
  map.resources :locations

  map.connect '/events/show/:id', :controller => 'events', :action => 'show'
  map.connect '/events/list',     :controller => 'events', :action => 'index'
  map.resources :events, :collection => {:add_location => :post}

  map.root :controller => "home"

  map.login  '/login',  :controller => 'member_sessions', :action => 'login'
  map.logout '/logout', :controller => 'member_sessions', :action => 'logout'
  # TODO add password reset

  #===[ Documentation ]===================================================

  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  ## map.connect ':controller/:action/:id'
  ## map.connect ':controller/:action/:id.:format'
end
