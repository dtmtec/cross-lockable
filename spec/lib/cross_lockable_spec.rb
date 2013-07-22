require "spec_helper"

describe CrossLockable do
  let!(:default_configuration) do
    {
      devise_scopes: [:user],
      auth_server_app: true,
      lockable_secret: ''
    }
  end

  after do
    default_configuration.each do |config, value|
      CrossLockable.send("#{config}=", value)
    end
  end

  it "has an accessor for devise scopes" do
    devise_scopes = [:user, :other_user]
    CrossLockable.devise_scopes = devise_scopes
    CrossLockable.devise_scopes.should eq(devise_scopes)
  end

  it "has an accessor for auth server app" do
    CrossLockable.auth_server_app = false
    CrossLockable.auth_server_app.should eq(false)
  end

  it "has an accessor for auth lockable secret" do
    secret = '1234567890'
    CrossLockable.lockable_secret = secret
    CrossLockable.lockable_secret.should eq(secret)
  end

  describe ".auth_server_app?" do
    it "returns true when auth_server_app is true" do
      CrossLockable.auth_server_app = true
      CrossLockable.auth_server_app?.should be_true
    end

    it "returns true when auth_server_app is false" do
      CrossLockable.auth_server_app = false
      CrossLockable.auth_server_app?.should be_false
    end
  end

  describe ".refresh_url_for" do
    let!(:options) { { url: 'http://test.com', return_to: 'http://returntotest.com' } }

    it "generates url based in options" do
      CrossLockable.refresh_url_for(options).should eq "#{options[:url]}?&return_to=#{options[:return_to]}"
    end
  end

  describe ".origin_url" do
    let!(:request) { double(:request, base_url: 'http://baseurl.com?', query_string: '?') }

    it "returns base url" do
      CrossLockable.origin_url(request).should eq 'http://baseurl.com'
    end
  end

  describe ".refresh_session_url" do
    it "returns refresh session url" do
      CrossLockable.refresh_session_url('http://test.com', 'User').should eq "http://test.com/cross_lockable/users/refresh_session"
    end
  end

end
