CrossLockable::Engine.routes.draw do

  devise_scope :users do
    match '/users/refresh_session' => 'cross_lockable/sessions#refresh', via: :post
  end

end
