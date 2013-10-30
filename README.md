# Cross Lockable

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/dtmtec/cross-lockable/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

Cross Lockable is a component that displays lock screen to re-authenticate an user without reloading the page.

## Requirements

* Rails
* jQuery
* Backbone JS
* Twitter Bootsrap
* SASS

## Installation

Add this line to your application's Gemfile

```ruby
gem 'cross-lockable', git: "git://github.com/dtmtec/cross-lockable.git", require: 'cross_lockable'
```

And then execute:

```console
bundle install
```

##Usage

Include Cross Lockable helper in your main helper:

```ruby
include CrossLockable::LockScreenHelper
```

Include Cross Lockable js

```
//= require cross_lockable/all
```

and css files

```
*= require cross_lockable/all
```

Mount Cross Lockable routes in your routes.rb:

```ruby
mount CrossLockable::Engine, at: "/cross_lockable"
```

Configure Cross Lockable options in your application.rb:

1 - Configure a Cross Lockable secret to ensure security in lock screen login.

```ruby
config.cross_lockable.lockable_secret = <YOUR SECRET>
```

2 - If your app is not a oauth server, set false. Default is true.

```ruby
config.cross_lockable.auth_server_app = false
```

3 - And configure your devise scopes for login. Cross Lockable will build routes for every scope configured here.

```ruby
config.cross_lockable.devise_scopes = [:user]
```

And finally render lock screen in your views:

```ruby
<%= render_lock_screen url: CrossLockable.refresh_session_url(root_url, 'user'),
                       scope: current_user,
                       return_to: cross_lockable.users_session_refreshed_url %>
```

![Lock Screen](https://raw.github.com/dtmtec/cross-lockable/master/doc/images/lock_screen.png)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
