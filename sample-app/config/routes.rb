Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  
  # You can have the root of your site routed with "root"
  root 'customers#new'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
    get 'customers/new' => 'customers#new'
    get 'customers/stripe_sign_up' => 'customers#stripe_sign_up'
    get 'customers/hosted_page_sign_up' => 'customers#hosted_page_sign_up'
    post 'customers/hosted_page_checkout_new' => 'customers#hosted_page_checkout_new'
    post 'customers/:id/hosted_page_checkout_existing' => 'customers#hosted_page_checkout_existing'
    post 'customers/checkout_new' => 'customers#checkout_new'
    post 'customers/:id/checkout_existing' => 'customers#checkout_existing'
    post 'customers/subscription_without_card' => 'customers#subscription_without_card'
    get 'customers/subscribe' => 'customers#subscribe'
    get 'customers/activate_subscription' => 'customers#activate_subscription'
    get 'customers/cancel_subscription/:id/:end_of_term' => 'customers#cancel_subscription'

    post 'customers/change_subscription' => 'customers#change_subscription'
    get 'customers/estimate' => 'customers#estimation'
    resources :customers do
      get 'add_plan', on: :member
    end

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
