class CrossLockable::SessionsController < DeviseController
  prepend_before_filter :allow_params_authentication!, :only => [ :refresh ]

  skip_before_filter :verify_authenticity_token, :only => [ :refresh ]

  layout false

  def refresh
    sign_out(resource_name)
    if CrossLockable::TokenGenerator.valid_token?(params[:token])
      request.env['refreshable'] = true
      resource = warden.authenticate!(scope: resource_name)
      sign_in(resource_name, resource)
      redirect_to "#{params[:return_to]}?message=success"
    else
      redirect_to "#{params[:return_to]}?message=invalid"
    end
  end

  def refreshed
    warden.authenticate!(scope: resource_name) if params[:message] == 'success'
  end
end
