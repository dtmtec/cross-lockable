CrossLockable::Engine.routes.draw do

  CrossLockable.devise_scopes.each do |scope|
    devise_scope scope.to_sym do
      get "#{scope.to_s.pluralize}/session_refreshed" => 'sessions#refreshed'

      if CrossLockable.auth_server_app?
        post "#{scope.to_s.pluralize}/refresh_session" => 'sessions#refresh'
      end
    end
  end
end
