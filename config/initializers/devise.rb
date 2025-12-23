# frozen_string_literal: true

# Assuming you have not yet modified this file, each configuration option below
# is set to its default value. Note that some configuration keys can be set
# to multiple values, for example `config.sign_in` can be set to
# `[:database, :database_authenticatable]`.

Devise.setup do |config|
  # The secret key used by Devise. Devise uses this key to generate
  # random tokens. Changing this key will render all cipher tokens and
  # encrypted passwords invalid, forcing users to reset their passwords
  # and making all remember me tokens invalid. Make sure the secret is at
  # least 30 characters and random. You can use `rails secret` to generate
  # a secure secret key.
  #
  # Make sure the secrets in this file are kept private if you're sharing
  # your code publicly.
  # config.secret_key = ENV["DEVISE_SECRET_KEY"]

  # ==> Controller configuration
  # Configure the parent class to the devise controllers.
  # config.parent_controller = "DeviseController"

  # ==> Mailer Configuration
  # Configure the e-mail address which will be shown in Devise::Mailer,
  # note that it will be overwritten if you configure your own mailer address
  # with config.mailer_sender.
  config.mailer_sender = 'please-change-me-at-config-initializers-devise@example.com'

  # Configure the class responsible for sending e-mails.
  config.mailer = "Devise::Mailer"

  # Configure the parent class responsible to send e-mails.
  # config.parent_mailer = "ActionMailer::Base"

  # ==> ORM configuration
  # Load and configure the ORM. Requires :authenticate_and_decrypt to work
  # properly.
  require 'devise/orm/active_record'

  # ==> Configuration for any authentication mechanism
  # Configure which keys are used when authenticating a user. The default is
  # just :email. You can configure it to use [:username, :subdomain], so for
  # authenticating a user, both parameters are required. Remember that those
  # parameters might also be required when registering a new user.
  config.authentication_keys = [:email]

  # Configure parameters from the request object used for authentication. Each
  # entry given should be a request method and it will automatically be passed
  # to the find_for_authentication method and considered in your model lookup.
  config.request_keys = []

  # Configure which authentication keys should be case-insensitive.
  # These keys will be downcased upon creating or modifying a user and when
  # authenticating them.
  config.case_insensitive_keys = [:email]

  # Configure which authentication keys should have whitespace stripped.
  # These keys will have whitespace stripped upon creating or modifying a user
  # and when authenticating them.
  config.strip_whitespace_keys = [:email]

  # Configure if authentication through request.params should be enabled.
  # True by default. It can be set to an array that will enable params authentication
  # only for the given strategies.
  # config.params_authenticatable = true

  # Configure if authentication through HTTP Auth is enabled. False by default.
  # It can be set to an array that will enable HTTP authentication for only the
  # given strategies.
  # config.http_authenticatable = false

  # Configure if email is required for authentication.
  config.require_authentication_on_email_change = true

  # If HTTP authentication is enabled, configure the realm used.
  # config.http_authentication_realm = "Application"

  # ==> Configuration for :database_authenticatable
  # For bcrypt, this is the cost for hashing the password and defaults to 12.
  # Using a higher value makes the password harder to crack but more CPU
  # intensive. This can be changed if a better algorithm is introduced.
  # Limit the password to a maximum length to prevent DoS attacks via
  # long passwords.
  config.password_length = 6..128

  # ==> Configuration for :confirmable
  # A period that the user is allowed to access the website even without
  # confirming their account. For instance, if set to 2.days, the user will
  # be able to access the website for 2 days without confirming their account,
  # access will be blocked just in the third day.
  # You can also set it to nil, which will allow the user to access the website
  # without confirming their account.
  # Default is 0.days, meaning the user cannot access the website without
  # confirming their account.
  config.allow_unconfirmed_access_for = 2.days

  # A period that the user is allowed to confirm their account before their
  # token becomes invalid. For example, if set to 3.days, the user can confirm
  # their account within 3 days after the mail was sent, but on the 4th day
  # their account cannot be confirmed with the token any more.
  # Default is nil, meaning there is no restriction on how long a user can take
  # to confirm their account.
  # config.confirm_within = 3.days

  # If true, requires any email changes to be confirmed (exactly the same way
  # as initial account confirmation) to be applied. Without additional configuration,
  # this adds an unconfirmed_email field to the user model, temporarily stores
  # the new email in the unconfirmed_email field, and sends an email confirmation.
  # When the user confirms, the new_email field is updated and the unconfirmed_email
  # field is cleared.
  config.reconfirmable = true

  # Defines which key will be used when confirming an account
  config.confirmation_keys = [:email]

  # ==> Configuration for :rememberable
  # The time the user will be remembered without asking for credentials again.
  config.remember_for = 2.weeks

  # Invalidates all the remember me tokens when the user signs out.
  config.expire_all_remember_me_on_sign_out = true

  # If true, extends the user's remember period when remembered via cookie.
  config.extend_remember_period = false

  # Options to be passed to the created cookie. For instance, you can set
  # secure or httponly flags.
  # config.rememberable_options = {}

  # ==> Configuration for :validatable
  # Range for password length.
  config.password_length = 6..128

  # Email regex used to validate email formats. A simple one that catches most
  # common email patterns is used by default.
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # ==> Configuration for :timeoutable
  # The time you want to timeout the user session without activity. After this
  # time the user will be asked for credentials again.
  # config.timeout_in = 30.minutes

  # ==> Configuration for :lockable
  # Defines which strategy will be used to lock an account.
  # :failed_attempts = Locks an account after a number of failed attempts.
  # :none            = No lock strategy. You should handle locking by yourself.
  config.lock_strategy = :failed_attempts

  # Defines which key will be used when locking and unlocking an account
  config.unlock_keys = [:email]

  # Defines which strategy will be used to unlock an account.
  # :email = Sends an unlock link to the user email
  # :time  = Re-enables login after a certain amount of time
  # :both  = Enables both strategies
  # :none  = No unlock strategy. You should handle unlocking by yourself.
  config.unlock_strategy = :both

  # Number of authentication tries before locking an account if lock_strategy
  # is failed attempts.
  config.maximum_attempts = 5

  # Time interval to unlock the account if :time is enabled as unlock_strategy.
  config.unlock_in = 1.hour

  # ==> Configuration for :recoverable
  #
  # Defines which key will be used when recovering the password for an account
  config.reset_password_keys = [:email]

  # Time interval you can reset your password with a reset password key.
  # After this interval, the user will need to request a new one.
  config.reset_password_within = 6.hours

  # When set to false, does not sign a user in automatically after their password
  # is reset. Defaults to true, so a user is signed in automatically after a reset.
  config.sign_in_after_reset_password = true

  # ==> Configuration for :encryptable
  # Allow you to use another encryption algorithm besides bcrypt (default). You can use
  # :sha1, :sha512 or encryptors from others authentication tools as :clearance_sha1,
  # :authlogic_sha512 (then you should set stretches above to 20 for default behavior)
  # and :restful_authentication_sha1 (then you should set stretches to 10, and copy
  # REST_AUTH_SITE_KEY to pepper).
  #
  # Require the `devise-encryptable` gem when using anything other than bcrypt
  # config.encryptor = :sha512

  # ==> Scopes configuration
  # Turn scoped views on. Before rendering "sessions/new", it will first
  # check for "users/sessions/new" within your app views. If it's not found,
  # it falls back to devise/sessions/new. This configuration setting can be
  # turned off to save some rendering time.
  config.scoped_views = true

  # Configure the default scope given to Warden. By default it's the first
  # devise role declared in your routes (usually :user).
  # config.default_scope = :user

  # Set this configuration to false if you want /users/sign_out to sign out
  # only the current scope. By default, Devise signs out all scopes.
  # config.sign_out_all_scopes = true

  # ==> Navigation configuration
  # Lists the formats that should be treated as navigational.
  # Formats like :html should be treated as navigational, while formats
  # like :json, :xml, or :js, should be excluded.
  config.navigational_formats = ['*/*', :html]

  # The default HTTP method used to sign out a resource. Default is :delete.
  config.sign_out_via = :delete

  # ==> OmniAuth
  # Add a new OmniAuth provider. Check the wiki for more information on
  # supported authentication strategies.
  # config.omniauth :github, 'APP_ID', 'APP_SECRET', scope: 'user,public_repo'

  # ==> Warden configuration
  # If you want to use other strategies, that are not supported by Devise, or
  # change the failure app, you can configure them inside the config.warden block.
  #
  # config.warden do |manager|
  #   manager.intercept_401 = false
  #   manager.default_strategies(scope: :user).unshift :some_external_strategy
  # end

  # ==> Mountable Engine configurations
  # When using Devise inside an engine, let's say myEngine, you have to set
  # Devise.rails_key = [:my_engine, :user]. If you are running it as a standalone
  # app, you can ignore this.
  # config.rails_key = [:user]

  # ==> Hotwire/Turbo configuration
  # When using Devise with Hotwire/Turbo, the http status for "respond_with"
  # in some controllers may not be correct. You can change this with the following
  # configuration:
  # navigational_formats: ['*/*', :html, :turbo_stream]

  # ==> Security enhancement
  # By default Devise will use the `strict` option for password validation.
  # This means a password will be considered invalid if it doesn't match
  # the configured requirements. Set this to false to disable this check.
  # config.password_complexity = { digit: 1, lower: 1, symbol: 1, upper: 1 }

  # ==> Configuration for :registerable
  # When set to false, the user must be signed in to edit their account.
  # The default is true.
  # config.allow_unsecured_access_to_profile = false
end
