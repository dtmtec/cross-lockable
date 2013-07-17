Devise.setup do |config|
  require 'devise/orm/mongoid'

  config.warden do |manager|
    manager.failure_app = RefreshableFailureApp
  end
end
