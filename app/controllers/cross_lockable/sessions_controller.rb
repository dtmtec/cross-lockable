class CrossLockable::SessionsController < DeviseController
  prepend_before_filter :require_no_authentication, :only => [ :new, :create ]
  prepend_before_filter :allow_params_authentication!, :only => [ :create, :refresh ]

  skip_before_filter :verify_authenticity_token, only: [:refresh]

  layout false

  def refresh
    request.env['refreshable'] = true
    sign_out(resource_name)
    resource = warden.authenticate!(scope: resource_name)
    sign_in(resource_name, resource)
    redirect_to "#{params[:return_to]}?message=success"
  end

  def refreshed
    warden.authenticate!(scope: resource_name) if params[:message] == 'success'
  end

end
