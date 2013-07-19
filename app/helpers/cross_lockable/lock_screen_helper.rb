module CrossLockable
  module LockScreenHelper
    def render_lock_screen(options={})
      render 'cross_lockable/lock_screen/lock_screen', {
        scope: options[:scope],
        url:    CrossLockable.refresh_url_for(options),
        origin: CrossLockable.origin_url(request),
        title: title(options),
        description: description(options)
      }
    end

    def title(options)
      options[:title] || t("cross_lockable.#{options[:scope]}.title", default: t('cross_lockable.title'))
    end

    def description(options)
      options[:description] || t("cross_lockable.#{options[:scope]}.description", default: t('cross_lockable.description'))
    end
  end
end
