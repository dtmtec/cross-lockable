module CrossLockable
  module LockScreenHelper
    def render_lock_screen(options={})
      render 'cross_lockable/lock_screen/lock_screen', {
        url:    CrossLockable.refresh_url_for(options),
        origin: CrossLockable.origin_url(request),
        scope: options[:scope],
        title: title(options),
        description: description(options),
        expiration_time: expiration(options)
      }
    end

    def expiration(options)
      options[:expiration_time] || 1800000
    end

    def title(options)
      options[:title] || t("cross_lockable.#{options[:scope]}.title", default: t('cross_lockable.title'))
    end

    def description(options)
      options[:description] || t("cross_lockable.#{options[:scope]}.description", default: t('cross_lockable.description'))
    end
  end
end
