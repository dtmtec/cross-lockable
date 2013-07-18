module CrossLockable
  module LockScreenHelper
    def render_lock_screen(options={})
      render 'cross_lockable/lock_screen/lock_screen', {
        url: CrossLockable.refresh_url_for(options),
        origin: CrossLockable.origin_url(request)
      }
    end
  end
end