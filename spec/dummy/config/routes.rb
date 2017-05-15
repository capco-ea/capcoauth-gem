Rails.application.routes.draw do
  use_capcoauth
  use_capcoauth scope: 'scope'

  scope 'inner_space' do
    use_capcoauth scope: 'scope' do
      controllers login: 'custom_login',
                  logout: 'custom_logout',
                  callback: 'custom_callback'

      as login: 'custom_in',
         logout: 'custom_out',
         callback: 'custom_cb'
    end
  end

  scope 'space' do
    use_capcoauth do
      controllers login: 'custom_login',
                  logout: 'custom_logout',
                  callback: 'custom_callback'

      as login: 'custom_in',
         logout: 'custom_out',
         callback: 'custom_cb'
    end
  end

  scope 'outer_space' do
    use_capcoauth do
      controllers login: 'custom_login',
                  logout: 'custom_logout',
                  callback: 'custom_callback'

      as login: 'custom_in',
         logout: 'custom_out',
         callback: 'custom_cb'

      skip_controllers :login, :logout, :callback
    end
  end

  get 'metal.json' => 'metal#index'

  get '/callback', to: 'home#callback'
  get '/sign_in',  to: 'home#sign_in'
  resources :semi_protected_resources
  resources :full_protected_resources
  root to: 'home#index'
end
