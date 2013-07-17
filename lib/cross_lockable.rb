require "cross_lockable/engine"
require "devise"

module CrossLockable
  mattr_accessor :devise_scopes
  @@devise_scopes = (ENV['DEVISE_SCOPES'] || 'user,supplier_user').split(',')

  def self.refresh_url_for(base_url)
    "base_url?&return_to=#{CrossLockable.refreshed_url}"
  end

  def self.refreshed_url
  end

  def self.origin_url(request)
    request.url.gsub(request.path, '').gsub(request.query_string, '').gsub('?', '')
  end
end
