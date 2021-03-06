Dummy::Application.routes.draw do
  get 'examples' => 'examples#index'

  mount CrossLockable::Engine, at: "cross_lockable"

  devise_for :users

  root to: 'home#index'
end
