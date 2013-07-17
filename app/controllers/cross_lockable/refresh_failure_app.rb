class CrossLockable::RefreshableFailureApp < Devise::FailureApp
  def redirect
    if request.env['refreshable']
      redirect_to "#{params[:return_to]}?message=invalid_credentials"
    else
      super
    end
  end
end