class CrossLockable::SessionsController < Devise::SessionsController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  prepend_before_filter :allow_params_authentication!, :only => [ :create, :refresh ]

  skip_before_filter :verify_authenticity_token, only: [:refresh]

  def refresh
    request.env['refreshable'] = true
    warden.logout(:user)
    resource = warden.authenticate!(scope: :user)
    sign_in(resource_name, resource)
    redirect_to "#{params[:return_to]}?message=success"
  end
end