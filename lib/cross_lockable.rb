module CrossLockable
  autoload :TokenGenerator, 'cross_lockable/token_generator'

  mattr_accessor :devise_scopes
  @@devise_scopes = [:user]

  mattr_accessor :auth_server_app
  @@auth_server_app = true

  mattr_accessor :lockable_secret
  @@lockable_secret = ''

  def self.auth_server_app?
    auth_server_app == true
  end

  def self.refresh_url_for(options)
    "#{options[:url]}?&return_to=#{options[:return_to]}"
  end

  def self.origin_url(request)
    request.base_url.gsub(request.query_string, '').gsub('?', '')
  end
end

require "cross_lockable/engine"
require "devise"