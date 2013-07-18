module CrossLockable
  class Engine < ::Rails::Engine
    isolate_namespace CrossLockable

    config.cross_lockable = CrossLockable

    initializer 'cross_lockable.devise' do
      Devise.setup do |config|
        config.warden do |manager|
          manager.failure_app = CrossLockable::RefreshableFailureApp
        end
      end
    end
  end
end
