# capcoauth-gem

Ruby Gem for integrating a Rails project with CapcOAuth

Currently, this only supports session-based authentication, but can easily be adapted to accept bearer tokens if needed.

## Installation

1.  Add to your gemfile:

```ruby
gem 'capcoauth'
```

2.  Run the following from your console to install the gem:

```sh
bundle install
```

3.  Run the following from your console to install the initializer in `config/initializers/capcoauth.rb`:

```sh
rails generate capcoauth:install
```

## Configure

### Enter your client_id and client_secret into initializer

You'll need to obtain an OAuth client ID and client secret for your application, which can then be entered into your
initializer in `config/initializers/capcoauth.rb`.

### Authorize your routes!

In your controllers, just call the helper method `verify_authorized!` for all protected resources.  This is easiest done
by adding it as a before_action:

```ruby
class ApplicationController < ActionController::Base
  before_action :verify_authorized
end
```

You may exclude/include for specific actions:

```ruby
class ApplicationController < ActionController::Base
  before_action :verify_authorized, only: [:my_super_secret_action], except: [:my_publicly_accessible_action]
end
```

Or even skip it entirely for specific actions:

```ruby
class PublicStuffController < ApplicationController
  skip_before_action :verify_authorized
end
```

## How it works

The installation script will add `use_capcoauth` to your `routes.rb` file, which creates these routes for you:

```
       Prefix Verb URI Pattern              Controller#Action
   auth_login GET  /auth/login(.:format)    capcoauth/login#show
  auth_logout GET  /auth/logout(.:format)   capcoauth/logout#show
auth_callback GET  /auth/callback(.:format) capcoauth/callback#show
```

These are very important, as they implement the core functionality of this gem.  The `login` route will generate a
CapcOAuth authorization URL appropriate for your application, and redirect the user to it.  Upon successful login and 
authorization of your application, they will be redirected to the `callback` route, which will exchange their code with
an access token, and will store that and the user's ID in the session.

Verification of the access token happens when `verify_authorized!` is executed, which caches the success response for
whatever TTL value you set in your initializer.  This saves time by preventing every request from calling home to 
CapcOAuth for approval.  This can be increased or decreased at your discretion, but should be kept to a relatively low
value.

## Bugs? Feature requests? Pull requests?

Email me or submit via issue/pull request.