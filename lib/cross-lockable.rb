require "cross-lockable/engine"

module CrossLockable
  mattr_accessor :devise_scopes
  @@devise_scopes = (ENV['DEVISE_SCOPES'] || 'user,supplier_user').split(',')
end
